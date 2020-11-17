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

desc "Duplicate Stock Number Search"
task :duplicate_stock_number_search => :environment do
  Dealership.all.each do |dealership|
    d = dealership
    vehicles = d.vehicles

    grouped_by_stock_number = vehicles.group(:stock_number).count.select{|k, v| v > 1}

    if grouped_by_stock_number.any?
      VehicleMailer.duplicate_stock_numbers(dealership, grouped_by_stock_number)
    end
  end
end

desc "Daily Checlist Generation"
task :generate_daily_checklists => :environment do
  Dealership.all.each do |dealership|
    DailyChecklistCreationService.new(dealership.id).perform!
  end
end