class BoardManagersController < ApplicationController

  def show
    deals = current_user.dealership.deals

    if params.dig(:filters, :mtd).present?
      sql = <<~SQL
              CASE 
                WHEN is_used = true 
                  THEN created_at > '"#{Date.today.beginning_of_month}"' 
                ELSE created_at > '"#{current_user.dealership.custom_mtd_start_date}"'
              END    
            SQL

      deals = deals.where(sql)
                    
    else
      deals = deals.where("created_at > ?", Date.today.beginning_of_day)
    end

    if params.dig(:filters, :query).present?
      deals = deals.where("client_last_name ILIKE ?", "%#{params.dig(:filters, :query)}%")
    end

    if params.dig(:sortings).present?
      params.dig(:sortings).each do |k,v|
        deals = deals.order(k => v)
      end
    end

    @deals = deals
  end
end