class SalesRepsController < ApplicationController

  def analytics
    
    @user = User.find(params[:sales_rep_id])
    service = SalesRepAnalyticsService.new(@user)
    

    @combined_deals_by_month = service.combined_deals_by_month
    @combined_deals_by_day = service.combined_deals_by_day
    @chart_data_month_counts_by_day = service.chart_data_month_counts_by_day
    
    @chart_monthly_counts_by_day = service.chart_monthly_counts_by_day
    @rolling_monthly_average_value = service.rolling_monthly_average_value
    
  end

end