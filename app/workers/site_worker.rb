class SiteWorker

  def perform
    sources.each do |source|
      urls = format_urls(source)
      invoke_crawler(source, urls)
    end
  end

  # https://www.deutscheoperberlin.de/en_EN/calendar?category_system=from_file&date=01.09.2019&p=2
  private

  def sources
    Source.all
  end

  def format_urls(source)
    urls = []
    current_time = Time.new

    # A year from now
    # TODO: configure it in database
    12.times do |index|
      urls << source.url + current_time.strftime(source.page_date_format)
      current_time = current_time + 1.month
    end
    urls
  end

  def invoke_crawler(source, urls)

    pool = Concurrent::FixedThreadPool.new(2)
    errors = Concurrent::Array.new
    urls.each do |url|
      Concurrent::Future.execute({ executor: pool }) do
        begin
          crawler = CrawlerWorker.new
          crawler.perform(source, url)
        rescue StandardError => e
          errors << e
        end
      end
    end

    # puts pool.running?
    # while pool.running?
    #   puts "waiting"
    #   if errors.any?
    #     pool.kill
    #     fail errors.first
    #   end
    #   sleep 10
    # end

    puts "Pool done"
  end

end
