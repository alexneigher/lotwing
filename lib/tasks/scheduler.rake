desc "Nightly Data Sync"
task :dealership_data_sync => :environment do
  Dealership.each do |d|
    DataFeedSyncService.new(d.id).perform!
  end
end