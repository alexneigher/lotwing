class DetailJobsController < ApplicationController

  def index
    @detail_jobs = current_user.dealership.detail_jobs.includes(:sales_rep, :detailer, vehicle: :events).order(:must_be_completed_by)
  end

  def create
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.create(detail_job_params)

    redirect_to detail_jobs_path
  end

  def start_job
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:detail_job_id])
    @detail_job.update(started_at: DateTime.now)

    redirect_to detail_jobs_path
  end

  def complete_job
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:detail_job_id])
    @detail_job.update(completed_at: DateTime.now)

    redirect_to detail_jobs_path
  end

  def reset_job
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.find(params[:detail_job_id])
    @detail_job.update(completed_at: nil, started_at: nil)

    redirect_to detail_jobs_path
  end


  def stock_number_search
    @vehicle = current_user.dealership.vehicles.find_by_stock_number(params[:stock_number])
  end

  private
    def detail_job_params
      params
        .require(:detail_job)
        .permit(
            :stock_number,
            :make,
            :model,
            :year,
            :color,
            :jobs,
            :vin,
            :sales_rep_id
          )
        .merge({must_be_completed_by: merged_completed_by_datetime})
    end

    def merged_completed_by_datetime
      timezone = Time.now.in_time_zone("US/Pacific").zone
      DateTime.strptime("#{params[:complete_by_date]} #{params[:complete_by_time]} #{timezone}", "%Y-%m-%d %l:%M %p %Z")
    end

end