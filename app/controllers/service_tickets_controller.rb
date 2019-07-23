class ServiceTicketsController < ApplicationController
  
  def index
    @service_tickets = current_user.dealership.service_tickets.includes(:created_by_user, :completed_by_user)
  end

  def new

  end

  def show
    @service_ticket = current_user
                        .dealership
                        .service_tickets
                        .includes(service_ticket_jobs: :user)
                        .find(params[:id])
  end

  def create   
    if service_ticket_params[:complete_by_datetime].present?
      datetime = DateTime.strptime("#{service_ticket_params[:complete_by_datetime]}", "%d %B %Y %l:%M %p %Z")
      formatted_complete_by_datetime = {complete_by_datetime: datetime}
    end
  

    @service_ticket = current_user.dealership.service_tickets.create(service_ticket_params.merge(formatted_complete_by_datetime))
    

    if @service_ticket.valid?
      if params[:service_ticket_job].present?
        @service_ticket.service_ticket_jobs.create(note: params[:service_ticket_job][:note], user_id: current_user.id)
      end

      redirect_to service_ticket_path(@service_ticket)
    else
      raise @service_ticket.errors.full_messages.to_s
    end
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


