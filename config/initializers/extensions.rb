Dir["#{Rails.root}/app/workers/*.rb"].sort.each { |file| require file }
