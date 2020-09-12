class ServiceTicketDepartmentsController < ApplicationController

  def update
    @service_ticket_department = ServiceTicketDepartment.find(params[:id])
    @service_ticket = @service_ticket_department.service_ticket

    @service_ticket_department.update!(service_ticket_department_params)

    redirect_to service_ticket_path(@service_ticket)
  end

  private
    def service_ticket_department_params
      params.require(:service_ticket_department).permit(:is_in_progress, :is_complete)
    end
end