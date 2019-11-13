class SalesRepsController < ApplicationController

  def analytics
    @user = User.find(params[:sales_rep_id])
    
    sales_rep_deals_grouped_by_month = Deal
                                          .where(sales_rep: @user.full_name)
                                          .where("created_at >= ? and created_at < ?", 3.months.ago.beginning_of_month, Date.current.beginning_of_month)
                                          .group("date_trunc('month', created_at) ")
                                          .count

    split_rep_deals_grouped_by_month = Deal
                                          .where(split_rep:@user.full_name)
                                          .where("created_at >= ? and created_at < ?", 3.months.ago.beginning_of_month, Date.current.beginning_of_month)
                                          .group("date_trunc('month', created_at) ")
                                          .count.map{|k, v| [k, v.to_f/2]}.to_h                               
                                   
    @combined_deals_by_month = sales_rep_deals_grouped_by_month.merge(split_rep_deals_grouped_by_month){ |k, a_value, b_value| a_value + b_value }.sort.to_h

    current_month_sales_deals_by_day = Deal
                                    .where(sales_rep: @user.full_name)
                                    .where("created_at >= ?", Date.current.beginning_of_month)
                                    .group("date_trunc('day', created_at) ")
                                    .count

    current_month_split_deals_by_day = Deal
                                    .where(split_rep: @user.full_name)
                                    .where("created_at >= ?", Date.current.beginning_of_month)
                                    .group("date_trunc('day', created_at) ")
                                    .count.map{|k, v| [k, v.to_f/2]}.to_h


    @combined_deals_by_day = current_month_sales_deals_by_day.merge(current_month_split_deals_by_day){ |k, a_value, b_value| a_value + b_value }.sort.to_h
    
    @chart_data_month_counts_by_day = []
    @chart_monthly_counts_by_day = []
    deals_created_by_day = @combined_deals_by_day.map{|k, v| [k.day, v]}.to_h
    sum = 0
    @days_this_month = (1..Date.current.day)
    
    @days_this_month.each do |i|
      deals_created_that_day = deals_created_by_day[i]

      @chart_data_month_counts_by_day << (sum += (deals_created_that_day || 0) )
    end 
    #creates an array like [1,2,2,2,3,3,3,4] incrementally increasing the sum until length = days this month  


    @rolling_monthly_average_value = ((@combined_deals_by_month.map{|k, v| v}.sum.to_f) / (@combined_deals_by_month.length)).round(0)
    
    a = *(1..Date.current.end_of_month.day)
    
    a.each do |i|
      @chart_monthly_counts_by_day << @rolling_monthly_average_value.to_f / (Date.current.end_of_month.day.to_f / (i))
    end

    #creates an array of linear deals per day ending up at the 3 month average
    
  end

end