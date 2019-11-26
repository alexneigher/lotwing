class DealsController < ApplicationController
  before_action :set_paper_trail_whodunnit, only: [:update, :create]

  def new
    @deal = Deal.new
  end

  def edit
    @deal = current_user.dealership.deals.includes(:versions).find(params[:id])
  end

  def create
    @deal = current_user.dealership.deals.create(deal_params)
    if @deal.valid?
      flash[:error] = nil
      redirect_to board_manager_path
    else
      flash[:error] = @deal.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @deal = current_user.dealership.deals.find(params[:id])
    @deal.update(deal_params)
    
    maybe_create_sales_hold(@deal.vehicle)

    if params[:commit] == "Print Cover Sheet"
      redirect_to deal_cover_sheet_path(@deal, format: :pdf) and return
    else
      redirect_to board_manager_path and return
    end
  end

  def destroy
    @deal = current_user.dealership.deals.find(params[:id])
    @deal.vehicle&.update(sold_status: nil) #mark associated vehicle as available
    @deal.destroy
    redirect_to board_manager_path
  end

  def cover_sheet
    @deal = current_user.dealership.deals.find(params[:deal_id] )

    respond_to do |format|
     format.pdf do
       render pdf: "Cover Sheet - #{@deal.client_last_name}",
       template: "deals/cover_sheet.html.haml",
       layout: 'pdf.html.erb',
       show_as_html: params.key?('debug')
     end
    end
  end

  def print_sold_sheet
    @deal = current_user.dealership.deals.find(params[:deal_id] )

    respond_to do |format|
     format.pdf do
       render pdf: "Sold Sheet",
       template: "deals/print_sold_sheet.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end


  def stock_number_search
    @vehicle = current_user.dealership.vehicles.where("stock_number ILIKE ?", "#{params[:stock_number]}").last
    @existing_stock_number_deals = current_user.dealership.deals.where("stock_number ILIKE ?", "#{params[:stock_number]}").any?
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
          :sales_rep_id,
          :split_rep_id,
          :city,
          :model,
          :make,
          :model_code,
          :is_used,
          :year,
          :result,
          :report_status,
          :deal_number,
          :deal_status,
          :pay_method,
          :deal_type,
          :selling_price,
          :down_payment,
          :term,
          :quoted_payment,
          :rate_apr,
          :miles_per_year,
          :rebates,
          :bulletin_number,
          :bank_name,
          :menu_number,
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
          :deal_date,
          :certified_pre_owned,
          :f_i_pre_sell,
          :f_i_pre_sell_product_list,
        ).merge(stored_param)
    end

    def stored_param
      return { stored: true } if params[:commit] == 'Store Entry'
      return { stored: false } if remove_stored_status?
    end

    def remove_stored_status?
      params[:commit] == "Update" || params[:create_with_hold] == "create_with_hold" || params[:create_with_hold] == "create_without_hold"
    end

    def maybe_create_sales_hold(vehicle)
      return unless vehicle.present?
      if params[:create_with_hold] == "create_with_hold"
        vehicle.update(sales_hold: true, sales_hold_notes: "Sales hold created by #{current_user.full_name}.")
      end
    end

end