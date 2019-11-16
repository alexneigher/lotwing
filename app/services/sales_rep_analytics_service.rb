class SalesRepAnalyticsService

  def initialize(user)
    @user = user

    @chart_data_month_counts_by_day = []
  end

  def combined_deals_by_month
    @combined_deals_by_month ||= sales_rep_deals_grouped_by_month.merge(split_rep_deals_grouped_by_month){ |k, a_value, b_value| a_value + b_value }.sort.to_h
  end

  def combined_deals_by_day
    @combined_deals_by_day ||= current_month_sales_deals_by_day.merge(current_month_split_deals_by_day){ |k, a_value, b_value| a_value + b_value }.sort.to_h
  end

  def chart_data_month_counts_by_day
    arr = []
    sum = 0
    deals_created_by_day = combined_deals_by_day.map{|k, v| [k.day, v]}.to_h

    days_this_month.each do |i|
      deals_created_that_day = deals_created_by_day[i]

      arr << (sum += (deals_created_that_day || 0) )
    end 

    return arr
  end
  #creates an array like [1,2,2,2,3,3,3,4] incrementally increasing the sum until length = days this month  

  def chart_monthly_counts_by_day
    arr = []
    
    a = *(1..Date.current.end_of_month.day)
    
    a.each do |i|
      arr << rolling_monthly_average_value.to_f / (Date.current.end_of_month.day.to_f / (i))
    end

    return arr
  end
  #creates an array of linear deal counts per day (this month) ending up at the 3 month average

  def rolling_monthly_average_value
    return 0 if combined_deals_by_month.length.zero?
    
    ((combined_deals_by_month.map{|k, v| v}.sum.to_f) / (combined_deals_by_month.length)).round(0)
  end
  #in the last 3 months, what is the average count

  def above_moving_average?
    delta = chart_data_month_counts_by_day[Date.current.day - 1] - chart_monthly_counts_by_day[Date.current.day - 1]
    #todays deal counts minus linear value for today, positive means you are above average

    return delta > 0
  end
  #returns whether or not this sales rep is above their monthly linear trend line by day, for todays date

  private
    def days_this_month
      (1..Date.current.day)
    end

    def sales_rep_deals_grouped_by_month 
      Deal
        .where(sales_rep: @user.full_name)
        .where("created_at >= ? and created_at < ?", 3.months.ago.beginning_of_month, Date.current.beginning_of_month)
        .group("date_trunc('month', created_at) ")
        .count
    end

    def split_rep_deals_grouped_by_month 
      Deal
        .where(split_rep: @user.full_name)
        .where("created_at >= ? and created_at < ?", 3.months.ago.beginning_of_month, Date.current.beginning_of_month)
        .group("date_trunc('month', created_at) ")
        .count.map{|k, v| [k, v.to_f/2]}.to_h  
    end

    def current_month_sales_deals_by_day 
      Deal
        .where(sales_rep: @user.full_name)
        .where("created_at >= ?", Date.current.beginning_of_month)
        .group("date_trunc('day', created_at) ")
        .count
    end

    def current_month_split_deals_by_day
      Deal
        .where(split_rep: @user.full_name)
        .where("created_at >= ?", Date.current.beginning_of_month)
        .group("date_trunc('day', created_at) ")
        .count.map{|k, v| [k, v.to_f/2]}.to_h
    end


end