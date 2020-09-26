module Dealerships
  class DetailJobConfigController < ApplicationController

    def index
      @dealership = current_user.dealership
    end

    def update
      @dealership = current_user.dealership
      @dealership.dealership_configuration.update(detail_job_config_params)

      redirect_to dealership_detail_job_config_index_path(@dealership)
    end


    private
      def detail_job_config_params
        params
          .require(:dealership_configuration)
          .permit(
              :detail_board_task_1,
              :detail_board_task_2,
              :detail_board_task_3,
              :detail_board_task_4,
              :show_detail_job_link_in_ui,
              :allow_sales_reps_to_create_detail_jobs,
              :detail_board_default_job_duration
            )
      end
  end
end