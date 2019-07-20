class ServiceTicketJobsController < ApplicationController

  def create
    @service_ticket = current_user.dealership.service_tickets.find(service_ticket_job_params[:service_ticket_id])

    if @service_ticket
      @service_ticket.service_ticket_jobs.create(service_ticket_job_params)
    end

    redirect_to service_ticket_path(@service_ticket)
  end


  private
    def service_ticket_job_params
      params.require(:service_ticket_job).permit(:note, :user_id, :service_ticket_id)
    end

end
