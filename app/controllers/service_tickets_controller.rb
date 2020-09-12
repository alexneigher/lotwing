class ServiceTicketsController < ApplicationController

  def index
    @service_tickets = current_user.dealership.service_tickets.includes(:created_by_user, :completed_by_user)

    if params.dig(:search, :stock_number)
      @service_tickets = @service_tickets.where(stock_number: params.dig(:search, :stock_number))
    end
  end

  def new

  end

  def show
    @service_ticket = current_user
                        .dealership
                        .service_tickets
                        .includes(service_ticket_jobs: [:user, :notes])
                        .find(params[:id])
  end

  def create
    if service_ticket_params[:complete_by_datetime].present?
      datetime = DateTime.strptime("#{service_ticket_params[:complete_by_datetime]}", "%d %B %Y %l:%M %p %Z")
      formatted_complete_by_datetime = {complete_by_datetime: datetime}
    end


    @service_ticket = current_user.dealership.service_tickets.create(service_ticket_params.merge(formatted_complete_by_datetime))

    if @service_ticket.valid?
      params[:service_ticket_jobs].each do |service_ticket_job|
        @service_ticket.vehicle.update(service_hold: true, service_hold_notes: "Service Ticket Created")
        @service_ticket.service_ticket_jobs.create(title: service_ticket_job[:title], user_id: current_user.id)
      end

      params[:service_ticket_departments].each do |service_ticket_department|
        @service_ticket.service_ticket_departments.create(name: service_ticket_department[:name])
      end

      #todo redirect to the right vehicle selected
      redirect_to vehicles_path
    else
      raise @service_ticket.errors.full_messages.to_s
    end
  end

  def destroy
    @service_ticket = current_user.dealership.service_tickets.find(params[:id])
    @service_ticket.destroy

    redirect_to service_tickets_path

  end


  def edit
    @service_ticket = current_user.dealership.service_tickets.find(params[:id])
  end

  def update
    @service_ticket = current_user.dealership.service_tickets.find(params[:id])

    if service_ticket_params[:complete_by_datetime].present?
      datetime = DateTime.strptime("#{service_ticket_params[:complete_by_datetime]} PST", "%d %B %Y %l:%M %p %Z")
      formatted_complete_by_datetime = {complete_by_datetime: datetime}
    end

    if service_ticket_params[:status] == "Complete"
      @service_ticket.vehicle.update(service_hold: false, service_hold_notes: nil)
    end

    @service_ticket.update(service_ticket_params.merge(formatted_complete_by_datetime))

    redirect_to service_ticket_path(@service_ticket)
  end

  def stock_number_search
    @vehicle = current_user.dealership.vehicles.where("stock_number ILIKE ?", "#{params[:stock_number]}").last
  end

  private
    def service_ticket_params
      params
        .require(:service_ticket)
        .permit(:vin,
                :stock_number,
                :created_by_user_id,
                :completed_by_user_id,
                :make,
                :model,
                :year,
                :mileage,
                :status,
                :complete_by_datetime,
                :color
              )
    end
end


