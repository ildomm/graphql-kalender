set :output, "#{Rails.root}/log/worker.log"

every 1.hours do
  rake 'explore:go'
end
