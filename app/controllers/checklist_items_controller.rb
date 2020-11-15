class ChecklistItemsController < ApplicationController

  def update
    daily_checklist = current_user.dealership.current_daily_checklist
    checklist_item = daily_checklist.checklist_items.find(params[:id])

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

    redirect_to lot_view_path
  end
end