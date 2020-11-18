module DailyChecklists
  class NotesController < ApplicationController

    def create
      daily_checklist = current_user.dealership.daily_checklists.find(params[:daily_checklist_id])

      daily_checklist.notes.create!(
        user_id: current_user.id,
        text: note_params[:text]
      )

      redirect_to lot_view_path
    end

    private
      def note_params
        params.require(:note).permit(:text)
      end
  end
end