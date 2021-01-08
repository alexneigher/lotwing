class BoardManagersController < ApplicationController

  def show
    deals = current_user.dealership.deals.includes(:split_rep, :sales_rep, :vehicle)

    if params.dig(:filters, :mtd) == '1'
      sql = <<~SQL
              CASE
                WHEN is_used = true
                  THEN deal_date >= '"#{DateTime.current.in_time_zone("Pacific Time (US & Canada)").beginning_of_month}"'
                ELSE deal_date >= '"#{current_user.dealership.custom_mtd_start_date}"'
              END
            SQL

      deals = deals.where(sql)

    elsif params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date), "%Y-%m-%d").beginning_of_day

      end_date = DateTime.strptime(params.dig(:filters, :end_date).presence || Date.today.strftime("%Y-%m-%d"), "%Y-%m-%d").end_of_day

      deals = deals.where("deal_date >= ? AND deal_date <= ?", start_date, end_date)
    else
      deals = deals.where("deal_date >= ?", DateTime.current.in_time_zone("Pacific Time (US & Canada)").to_date)
    end

    if params.dig(:filters, :query).present?
      deals = current_user.dealership.deals.where(stored: false).where("client_last_name ILIKE ? OR stock_number ILIKE ?", "%#{params.dig(:filters, :query)}%", "%#{params.dig(:filters, :query)}%")
    end

    #filter by new model groupings
    if params.dig(:filters, :model).present?
      deals = deals.where(is_used: false, stored: false, model: params.dig(:filters, :model) )
    end

    #filter by sales rep
     #filter by new model groupings
    if params.dig(:filters, :sales_rep_id).present?
      deals = deals.where(sales_rep_id: params.dig(:filters, :sales_rep_id) )
    end


    if params.dig(:filters, :new_vehicles).present? || params.dig(:filters, :used).present?
      if params.dig(:filters, :new_vehicles) == '0' && params.dig(:filters, :used) == "1"
        deals = deals.where(is_used: true)
      elsif params.dig(:filters, :new_vehicles) == '1' && params.dig(:filters, :used) == "0"
        deals = deals.where(is_used: false)
      elsif params.dig(:filters, :new_vehicles) == '1' && params.dig(:filters, :used) == "1"
        deals = deals
      else #both are 0?
        deals = deals.none
      end
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        if k == "sales_rep"
          user_ids = current_user.dealership.users.order("full_name #{v}").pluck(:id)
          deals = deals.order_by_rep_ids(user_ids, "sales_rep_id")
        else
          deals = deals.order(k => v)
        end
      end
    end

    @deals = deals

    @grouped_deals = deals.group_by{|d| d.deal_date}.sort_by{|k, v| k}.to_h

    @grouped_by_vehicle = deals.where(is_used: false, stored: false).group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h
  end


  def stored_deals
    @deals = current_user.dealership.deals.includes(:split_rep, :sales_rep, :vehicle).included_in_counts.where(stored: true)
  end

  def new_vehicle_report
    if params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date), "%Y-%m-%d").beginning_of_day
      end_date = DateTime.strptime(params.dig(:filters, :end_date).presence || Date.today.strftime("%Y-%m-%d"), "%Y-%m-%d").end_of_day
      @deals = current_user.dealership.deals.included_in_counts.where(stored: false, is_used: false).where("deal_date >= ? AND deal_date <= ?", start_date, end_date)
    else
      @deals = current_user.dealership.deals.included_in_counts.where(stored: false, is_used: false).where("deal_date >= ?", current_user.dealership.custom_mtd_start_date)
    end

    @grouped_deals = @deals.group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h
  end

  def rdr_report
    @deals = current_user.dealership.deals.includes(:split_rep, :sales_rep, :vehicle).included_in_counts.where(stored: false, is_used: false)

    if params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date, :vehicle), "%Y-%m-%d").beginning_of_day

      end_date = DateTime.strptime(params.dig(:filters, :end_date).presence || Date.today, "%Y-%m-%d").end_of_day

      @deals = @deals.where("deal_date >= ? AND deal_date <= ?", start_date, end_date)
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        @deals = @deals.order(k => v)
      end
    end

    @grouped_deals = @deals.group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h

    respond_to do |format|
      format.pdf do
         render pdf: "RDR Report",
         template: "board_managers/printed_rdr_report.html.haml",
         layout: 'pdf.html.erb'
       end

      format.html
    end
  end

  def cpo_report
    @deals = current_user
              .dealership
              .deals
              .includes(:split_rep, :sales_rep, :vehicle)
              .included_in_counts
              .where(stored: false, certified_pre_owned: true)
              .where("deal_date >= ?", current_user.dealership.custom_mtd_start_date)
              .where("make ILIKE ? OR make ILIKE ?", "Volkswagen", "VW")

    @grouped_deals = @deals.group_by{|d| d.model}.sort_by{ |k, v| v.count }.to_h
  end

  def used_vehicle_report
    @deals = current_user.dealership.deals.includes(:split_rep, :sales_rep).included_in_counts.where(stored: false, is_used: true).where("deal_date >= ?", DateTime.now.in_time_zone("Pacific Time (US & Canada)").beginning_of_month)
    @grouped_deals = @deals.group_by{|d| d.deal_date}.sort_by{|k, v| k}.to_h
  end

  def running_total
    if params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date), "%Y-%m-%d").beginning_of_day
      end_date = DateTime.strptime(params.dig(:filters, :end_date).presence || Date.today.strftime("%Y-%m-%d"), "%Y-%m-%d").end_of_day
      @deals = current_user.dealership.deals.includes(:split_rep, :sales_rep, :vehicle).where(stored: false).where("deal_date >= ? AND deal_date <= ?", start_date, end_date)
    else
      @deals = current_user.dealership.deals.includes(:split_rep, :sales_rep, :vehicle).where(stored: false)
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        @deals = @deals.order(k => v)
      end
    end

    if params.dig(:filters, :f_i_pre_sell) == '1'
      @deals = @deals.where(f_i_pre_sell: true)
    end

    @grouped_deals = @deals.group_by{|d| d.deal_date}.sort_by{ |k, v| k}.to_h

    respond_to do |format|
      format.pdf do
         render pdf: "Running Total Report",
         template: "board_managers/printed_running_totals_report.html.haml",
         layout: 'pdf.html.erb'
       end

      format.html
    end
  end

end