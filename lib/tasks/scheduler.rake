desc "Nightly Data Sync"
task :dealership_data_sync => :environment do
  Dealership.all.each do |d|
    DataFeedSyncService.new(d.id).perform!
  end
end


desc "Nightly Sales Rep Moving Average Calc"
task :sales_rep_average_calcs => :environment do
  User.all.each do |user|
    s = SalesRepAnalyticsService.new(user)
    user.update(sales_rep_above_monthly_moving_average: s.above_moving_average?)
  end
end