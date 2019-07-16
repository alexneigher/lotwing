class ServiceTicketsController < ApplicationController
  
  def index
    @service_tickets = current_user.dealership.service_tickets.includes(:created_by_user, :completed_by_user)
  end

  def new
  end

  def create

  end

  def edit

  end

  def stock_number_search
    @vehicle = current_user.dealership.vehicles.where("stock_number ILIKE ?", "#{params[:stock_number]}").last
  end

  private
    def service_ticket_params
      params.require(:service_ticket).permit(:vin, :stock_number, :created_by_user_id, :completed_by_user_id, :make, :model, :year, :mileage, :status, :complete_by_datetime, :color)
    end
end