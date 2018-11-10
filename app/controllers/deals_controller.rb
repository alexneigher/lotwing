class DealsController < ApplicationController
  before_action :set_paper_trail_whodunnit, only: [:update, :create]

  def new
    @deal = Deal.new
  end

  def edit
    @deal = current_user.dealership.deals.includes(:versions).find(params[:id])
  end

  def create
    current_user.dealership.deals.create(deal_params)
    redirect_to board_manager_path
  end

  def update
    @deal = current_user.dealership.deals.find(params[:id])
    @deal.update(deal_params)
    redirect_to board_manager_path
  end

  def cover_sheet
    @deal = current_user.dealership.deals.find(params[:deal_id] )

    respond_to do |format|
     format.pdf do
       render pdf: "Cover Sheet - #{@deal.client_last_name}",
       template: "deals/cover_sheet.html.haml",
       layout: 'pdf.html.erb'
     end
    end

  end


  private
    def user_for_paper_trail
      current_user.full_name
    end

    def deal_params
      params
        .require(:deal)
        .permit(
          :client_last_name,
          :source,
          :stock_number,
          :trade,
          :sales_rep,
          :split_rep,
          :city,
          :model,
          :make,
          :is_used,
          :year,
          :result,
          :report_status,
          :deal_number,
          :pay_method,
          :deal_type,
          :selling_price,
          :down_payment,
          :term,
          :quoted_payment,
          :rate_apr,
          :miles_per_year,
          :rebates,
          :program_description,
          :desk_manager,
          :finance_manager,
          :dealer_demo,
          :loaner_car,
          :disclosure,
          :trade_allowance,
          :trade_acv,
          :trade_payoff_amount,
          :trade_bank_name,
          :good_through_date,
          :trade_account_number,
          :send_payoff_address,
          :time_agreed,
          :time_in_finance,
          :time_out_finance,
          :deal_notes,
          :missing_stips_1,
          :missing_stips_2,
          :certified_pre_owned
        )
    end
end