class DetailJobsController < ApplicationController

  def index
    @detail_jobs = current_user.dealership.detail_jobs
  end

  def create
    @dealership = current_user.dealership
    @detail_job = @dealership.detail_jobs.create(detail_job_params)
  end

  def stock_number_search
    @vehicle = current_user.dealership.vehicles.find_by_stock_number(params[:stock_number])
  end

  private
    def detail_job_params
      params
        .require(:detail_job)
        .permit(:stock_number)
        .merge({must_be_completed_by: merged_completed_by_datetime})
    end

    def merged_completed_by_datetime
      timezone = Time.now.in_time_zone("US/Pacific").zone
      DateTime.strptime("#{params[:complete_by_date]} #{params[:complete_by_time]} #{timezone}", "%Y-%m-%d %l:%M %Z")
    end

end