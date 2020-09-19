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
end