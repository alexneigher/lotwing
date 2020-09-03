class Dealerships::DeletedRecordsController < ApplicationController

  def index
    @dealership = current_user.dealership

    @deleted_vehicles = @dealership.vehicles.includes(:versions).only_deleted

    @deleted_deals = @dealership.deals.includes(:versions).only_deleted


    if params.dig(:filters, :stock_number).present?
      @deleted_vehicles = @deleted_vehicles.where("stock_number ilike ?", "%#{params.dig(:filters, :stock_number)}%")
      @deleted_deals = @deleted_deals.where("stock_number ilike ?", "%#{params.dig(:filters, :stock_number)}%")
    end

    if params.dig(:filters, :start_date).present?
      start_date = DateTime.strptime(params.dig(:filters, :start_date), "%Y-%m-%d").beginning_of_day

      @deleted_vehicles = @deleted_vehicles.where("deleted_at >= ?", start_date)
      @deleted_deals = @deleted_deals.where("deleted_at >= ?", start_date)
    end

    if params.dig(:filters, :end_date).present?
      end_date = DateTime.strptime(params.dig(:filters, :end_date), "%Y-%m-%d").end_of_day

      @deleted_vehicles = @deleted_vehicles.where("deleted_at <= ?", end_date)
      @deleted_deals = @deleted_deals.where("deleted_at <= ?", end_date)
    end

  end
end