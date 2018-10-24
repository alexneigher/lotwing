class DealsController < ApplicationController

  def new
    @deal = Deal.new
  end

  def edit
    @deal = current_user.dealership.deals.find(params[:id])
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


  private
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
          :discloser,
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
        )
    end
end