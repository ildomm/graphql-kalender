require 'net/http'
require 'uri'
require 'nokogiri'
require 'selenium-webdriver'

class CrawlerWorker
  # TODO: define worker own logger

  def perform(source, url)
    puts "Processing url: #{source.name} | #{url}"
    time_start = Time.now

    @source = source
    @url = url
    @events = []

    # Define parsers config
    @config = JSON.parse(source.config)

    # Extraction step
    case @config['driver']
    when 'selenium'
      return unless extract_with_selenium
    when 'nokogiri'
      return unless extract_with_nokogiri
    else
      return
    end

    puts "url: #{@url}, size: #{@content.length}, events: #{@events.length}"

    # Database step
    persist

    # Analysis step
    minutes, seconds = time_split(time_start, Time.now)
    puts "Execution time: #{minutes} minutes, #{seconds} seconds"
  end

  private

  # TODO: Implement
  # For websites such https://www.deutscheoperberlin.de
  # it is necessary because lazy load when using JS
  def extract_with_selenium
    false
  end

  def contents
    @content = Net::HTTP.get_response(URI.parse(@url)).body
    true
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    false
  end

  def extract_with_nokogiri
    return unless contents

    page = Nokogiri::HTML(@content)

    # TODO: Improve dinamicu Such rude way to navigate over tahts
    page.xpath(@config['xpath']).each do |element|
      # TODO: improve validations
      # Still a such rude way to navigate over tags
      # Only requires time to implement a better way of splitting elements

      config = @config['url'].split('|')
      url = element.at_css(config[0]).attr(config[1])

      config = @config['title'].split('|')
      title = element.at_css(config[0]).attr(config[1])
      title = element.at_css(config[0]).at_css(config[1]).text if title.nil?

      start_at = ''
      config = @config['dates'].split('|')
      if config.length == 1
        start_at = element.at_css(config[0]).text
      else
        start_at = element.at_css(config[0]).attr(config[1])
        unless config[2].nil?
          start_at = start_at.split(config[2])
          start_at = start_at[start_at.length - 1]
        end
      end

      start_at = parse_date(start_at, title, url)
      end_at = start_at
      @events << { url: url, start_at: start_at, end_at: end_at, title: title }
    end

    true
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    false
  end

  def parse_date(text, title, url)
    text = text.strip
    text = text.gsub "\t", ''
    text = text.gsub title, ''
    text = text.gsub url, ''

    DateTime.parse(text)
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    nil
  end

  def persist
    @events.each do |candidate|
      url = candidate[:url]
      url = @source.url + candidate[:url] unless url.include? 'http'

      # Check existence
      next unless Event.find_by_url(url).nil?

      Event.create!(
        source: @source,
        url: url,
        start_at: candidate[:start_at],
        end_at: candidate[:end_at],
        title: candidate[:title]
      )
    end
  end

  def time_split(time_start, time_end)
    seconds = ((time_end - time_start)).round
    minutes = ((time_end - time_start) / 60).round
    [minutes, seconds]
  end
end
