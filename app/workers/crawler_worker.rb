require 'net/http'
require 'uri'
require 'nokogiri'

module TimeSplitter
  def self.call(time_start, time_end)
    seconds = ((time_end - time_start)).round
    minutes = ((time_end - time_start) / 60).round
    [minutes, seconds]
  end
end

class CrawlerWorker

  # TODO: define worker logger

  def perform(source, url)
    puts "Processing url: #{@source.name} | #{@url}"
    time_start = Time.now

    @source = source
    @url = url
    @events = []

    unless contents
      return
    end
    puts "url: #{@url} size #{@content.length}"

    unless extract
      return
    end
    puts "url: #{@url} events: #{@events.length}"

    persist

    minutes, seconds = TimeSplitter.call(time_start, Time.now)
    puts "Execution time: #{minutes} minutes, #{seconds} seconds"
  end

  private

  def contents
    @content = Net::HTTP.get_response(URI.parse(@url)).body
    true
  rescue StandardError => error
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")

    false
  end

  def extract
    page = Nokogiri::HTML(@content)
    page.xpath("//h4").each do |element|
      url = element.at_css('a').attr('href')
      title = element.at_css('a').at_css('span').text

      start_at = parse_date( element.at_css('a').text, title, url )
      end_at = parse_date( element.at_css('a').text, title, url )

      @events << { url: url, start_at: start_at, end_at: end_at, title: title }
    end

    puts "url: #{@url} events: #{@events.length}"

    return true
  rescue StandardError => error
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")

    false
  end

  def parse_date( text, title, url )
    text = text.strip
    text = text.gsub "\t",''
    text = text.gsub title,''
    text = text.gsub url,''

    DateTime.parse(text)
  end

  def persist
    @events.each do |candidate|
      url = @source.url + candidate[:url]

      # Check existence
      if Event.find_by_url(url) == nil
        Event.create!(
            source: @source,
            url: url,
            start_at: candidate[:start_at],
            end_at: candidate[:end_at],
            title: candidate[:title]
        )
      end
    end

  end

end



