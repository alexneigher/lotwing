class SalesRepsController < ApplicationController

  def analytics
    @user = User.find(params[:sales_rep_id])
    @sales_rep_deals_grouped_by_month = Deal
                                          .where("sales_rep = ? OR split_rep = ?", @user.full_name, @user.full_name)
                                          .where("created_at >= ? and created_at < ?", 3.months.ago.beginning_of_month, Date.current.beginning_of_month)
                                          .group("date_trunc('month', created_at) ")
                                          .count.sort
                                          
    @current_month_deals_by_day = Deal
                                    .where("sales_rep = ? OR split_rep = ?", @user.full_name, @user.full_name)
                                    .where("created_at >= ?", Date.current.beginning_of_month)
                                    .group("date_trunc('day', created_at) ")
                                    .count

    @chart_data_month_counts_by_day = []
    
    deals_created_by_day = @current_month_deals_by_day.map{|k, v| [k.day, v]}.to_h
    sum = 0
    @days_this_month = (1..Date.current.day)
    
    @days_this_month.each do |i|
      deals_created_that_day = deals_created_by_day[i]

      @chart_data_month_counts_by_day << (sum += (deals_created_that_day || 0) )
    end 
    #creates an array like [1,2,2,2,3,3,3,4] incrementally increasing the sum until length = days this month  

  end

end