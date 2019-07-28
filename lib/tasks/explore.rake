namespace :explore do
  task go: [:environment] do
    worker = SiteWorker.new
    worker.perform(true)
  end
end
