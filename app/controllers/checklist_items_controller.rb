class ChecklistItemsController < ApplicationController

  def update
    checklist_item = ChecklistItem.find(params[:id])

    if params[:complete] == "1"
      checklist_item
        .update(
          completed_at: DateTime.current,
          completed_by_user_id: current_user.id
        )
    else
      checklist_item
        .update(
          completed_at: nil,
          completed_by_user_id: nil
        )
    end

    if params[:redirect_to].present?
        redirect_to params[:redirect_to]
    else
      redirect_to lot_view_path
    end
  end
end