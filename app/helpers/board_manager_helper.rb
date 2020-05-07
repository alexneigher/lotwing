module BoardManagerHelper

  def sales_reps_for_pickers(all_users)
    reps = all_users.sales_rep.pluck(:full_name, :id) + ["-----"] + all_users.sales_manager.pluck(:full_name, :id)
  end
end
