module Crawler
  def self.run(number)
    puts "number : #{number}"

    # loop de 12 meses
    #
    # formatar url por padrao do source
    # criar pool para processar uma url por thread
  end
end

module TimeSplitter
  def self.call(time_start, time_end)
    seconds = ((time_end - time_start)).round
    minutes = ((time_end - time_start) / 60).round
    [minutes, seconds]
  end
end