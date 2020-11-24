module DailyChecklistHelper

  def daily_checklist_report_bg_class(checklist, team_name)

    if checklist.any_items_for?(team_name)
      return 'bg-white text-dark border'
    else
      checklist.all_items_completed_for?(team_name) ? 'bg-success' : 'bg-danger'
    end
  end
end