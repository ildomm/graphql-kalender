class SiteWorker
  # Default sources config, first version
  # A http://berghain.de
  # {"page_format":"/events/%Y-%m","driver":"nokogiri","xpath":"//h4","url":"a|href","title":"a|span","dates":"a"}
  # B https://gorki.de
  # {"page_format":"/en/programme/%Y/%m/all","driver":"nokogiri","xpath":"//*[@id=\"block-gorki-content\"]/div[1]/*","url":"a|href","title":"a|title","dates":"a|href|/"}

  def perform(has_to_wait)
    @has_to_wait = has_to_wait
    sources.each do |source|
      urls = format_urls(source)
      invoke_crawler(source, urls)
    end
  end


  private

  def sources
    Source.all
  end

  def format_urls(source)
    urls = []
    current_time = Time.new
    config = JSON.parse(source.config)

    # A year from now only
    12.times do |_index|
      urls << source.url + current_time.strftime(config['page_format'])
      current_time += 1.month
    end
    urls
  end

  def invoke_crawler(source, urls)
    pool = Concurrent::FixedThreadPool.new(3)
    errors = Concurrent::Array.new
    crawler = CrawlerWorker.new

    # Split inside threads the real "work" over pages
    urls.each do |url|
      Concurrent::Future.execute({ executor: pool }) do
        crawler.perform(source, url)
      rescue StandardError => e
        errors << e
      end
    end

    if @has_to_wait
      pool.shutdown
      pool.wait_for_termination
    end

    return unless errors.size.positive?

    puts errors.inspect
  end
end
