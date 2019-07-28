namespace :explore do
  task go: [:environment] do
    puts "Started"
    pool = Concurrent::FixedThreadPool.new(5)

    i = 1
    time_start = Time.now

    10.times do |i|
      pool.post do
        time_start = Time.now
        sleep rand(3)
        puts i


        time_end = Time.now
        minutes, seconds = TimeSplitter.call(time_start, time_end)
        puts "time: #{minutes}minutes, #{seconds}seconds"

        Crawler.run(i)
      end
    end

    pool.shutdown
    pool.wait_for_termination
  end
end
