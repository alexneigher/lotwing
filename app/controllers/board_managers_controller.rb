class BoardManagersController < ApplicationController

  def show
    deals = current_user.dealership.deals.where(stored: false)

    if params.dig(:filters, :mtd) == '1'
      sql = <<~SQL
              CASE 
                WHEN is_used = true 
                  THEN deal_date >= '"#{Date.today.beginning_of_month}"' 
                ELSE deal_date >= '"#{current_user.dealership.custom_mtd_start_date}"'
              END    
            SQL

      deals = deals.where(sql)

    elsif params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date), "%Y-%m-%d").beginning_of_day
      
      end_date = DateTime.strptime(params.dig(:filters, :end_date).presence || Date.today, "%Y-%m-%d").end_of_day
      
      deals = deals.where("deal_date >= ? AND deal_date <= ?", start_date, end_date)
    else
      deals = deals.where("deal_date >= ?", DateTime.current.in_time_zone("Pacific Time (US & Canada)").to_date)
    end

    if params.dig(:filters, :query).present?
      deals = current_user.dealership.deals.where(stored: false).where("client_last_name ILIKE ? OR stock_number ILIKE ?", "%#{params.dig(:filters, :query)}%", "%#{params.dig(:filters, :query)}%")
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        deals = deals.order(k => v)
      end
    end

    @deals = deals
    @grouped_deals = deals.group_by{|d| d.deal_date}.sort_by{|k, v| k}.to_h
  end


  def stored_deals
    @deals = current_user.dealership.deals.included_in_counts.where(stored: true)
  end

  def new_vehicle_report
    @deals = current_user.dealership.deals.included_in_counts.where(stored: false, is_used: false).where("deal_date >= ?", current_user.dealership.custom_mtd_start_date)
    @grouped_deals = @deals.group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h
  end

  def cpo_report
    @deals = current_user
              .dealership
              .deals
              .included_in_counts
              .where(stored: false, certified_pre_owned: true)
              .where("deal_date >= ?", current_user.dealership.custom_mtd_start_date)
              .where("make ILIKE ? OR make ILIKE ?", "Volkswagen", "VW")

    @grouped_deals = @deals.group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h
  end

  def used_vehicle_report
    @deals = current_user.dealership.deals.included_in_counts.where(stored: false, is_used: true).where("deal_date >= ?", Date.today.beginning_of_month)
    @grouped_deals = @deals.group_by{|d| d.deal_date}.sort_by{|k, v| k}.to_h
  end

  def running_total
    @deals = current_user.dealership.deals.where(stored: false)
    @grouped_deals = @deals.group_by{|d| d.deal_date}.sort_by{ |k, v| k}.to_h
  end

end