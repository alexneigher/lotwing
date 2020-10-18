module DetailJobHelper
  def detail_job_bg_class(job)
    case job.status
      when :in_progress
        "bg-yellow"
      when :not_started
        "bg-danger"
      when :complete
        "bg-green"
      end
  end

  def detail_job_text_color(job)
    case job.status
      when :in_progress
        "text-dark"
      when :not_started, :complete
        "text-white"
      end
  end

  def detail_job_complete_by_time(dealership)
    current_time = Time.now.in_time_zone("US/Pacific")
    custom_duration = dealership.dealership_configuration.detail_board_default_job_duration

    additional_hours = custom_duration.split(":")[0]
    additional_minutes = custom_duration.split(":")[1]

    time_plus_hours = current_time + (additional_hours.to_i).hours
    time_plus_minutes = time_plus_hours + (additional_minutes.to_i).minutes

    time_plus_minutes.strftime("%l:%M %p")
  end

  def all_detailers
    current_user.dealership.users.active.detail_job_user.pluck(:full_name, :id)
  end
end