class ServiceTicketDepartmentsController < ApplicationController

  def update
    @service_ticket_department = ServiceTicketDepartment.find(params[:id])
    @service_ticket = @service_ticket_department.service_ticket


    @service_ticket_department.update!(service_ticket_department_params)

    assign_ownership_of_change

    redirect_to service_ticket_path(@service_ticket)
  end

  private
    def service_ticket_department_params
      params.require(:service_ticket_department).permit(:is_in_progress, :is_complete)
    end

    def assign_ownership_of_change
      # mark complete or nil
      if @service_ticket_department.saved_change_to_is_complete?
         #someone just checked the box
        if @service_ticket_department.is_complete?
          @service_ticket_department.update!(completed_by_user_id: current_user.id, completed_at: Time.now)
        else
          #someone just unchecked the box
          @service_ticket_department.update!(completed_by_user_id: nil, completed_at: nil)
        end
      end

      #assign in progress or nil
      if @service_ticket_department.saved_change_to_is_in_progress?
        #someone just checked the box
        if @service_ticket_department.is_in_progress?
          @service_ticket_department.update!(in_progress_by_user_id: current_user.id, marked_in_progress_at: Time.now)
        else
          #someone just unchecked the box
          @service_ticket_department.update!(in_progress_by_user_id: nil, marked_in_progress_at: nil)
        end
      end
    end

end