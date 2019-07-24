class NotesController < ApplicationController

  def create
    @service_ticket_job = ServiceTicketJob.find(params[:note][:service_ticket_job_id])
    @service_ticket_job.notes.create( note_params.merge(user_id: current_user.id) )

    redirect_to service_ticket_path(@service_ticket_job.service_ticket)
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @note.update(note_params)

    redirect_to service_ticket_path(@note.service_ticket_job.service_ticket)
  end

  private
    def note_params
      params.require(:note).permit(:text, :service_ticket_job_id)
    end

end