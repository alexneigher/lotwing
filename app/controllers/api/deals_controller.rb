module Api
  class DealsController < Api::BaseController

    def index
      deals = current_user.dealership.deals.all
      json_response(deals)
    end

    def mtd
      deals = current_user.dealership.deals

      sql = <<~SQL
              CASE 
                WHEN is_used = true 
                  THEN deal_date >= '"#{DateTime.current.in_time_zone("Pacific Time (US & Canada)").beginning_of_month}"' 
                ELSE deal_date >= '"#{current_user.dealership.custom_mtd_start_date}"'
              END    
            SQL

      deals = deals.where(sql)

      json_response(deals)
    end

    def today
      deals = current_user.dealership.deals.all

      deals = deals.where("deal_date >= ?", DateTime.current.in_time_zone("Pacific Time (US & Canada)").to_date)

      json_response(deals)
    end

  end
end