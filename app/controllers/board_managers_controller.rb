class BoardManagersController < ApplicationController

  def show
    deals = current_user.dealership.deals

    if params.dig(:filters, :mtd).present?
      deals = deals.where("created_at > ?", Date.today.beginning_of_month)
    else
      deals = deals.where("created_at > ?", Date.today.beginning_of_day)
    end

    if params.dig(:filters, :query).present?
      deals = deals.where("client_last_name ILIKE ?", "%#{params.dig(:filters, :query)}%")
    end

    @deals = deals
  end
end