class DealerTradesController < ApplicationController
  before_action :set_paper_trail_whodunnit, only: [:update, :create]

  def index
    @dealer_trades = current_user.dealership.dealer_trades

    if params.dig(:sort).present?
      params.dig(:sort).each do |k,v|
        @dealer_trades = @dealer_trades.order(k => v)
      end
    end
  end

  def new
  end

  def create
    @dealer_trade = current_user.dealership.dealer_trades.create(dealer_trade_params)

    suggested_trade_dealership = current_user
                                  .dealership
                                  .suggested_trade_dealerships
                                  .find_or_create_by(
                                      name: params[:dealer_trade][:trade_dealer_name],
                                      address: params[:dealer_trade][:trade_dealer_address],
                                      phone: params[:dealer_trade][:trade_contact_phone],
                                      contact: params[:dealer_trade][:trade_dealer_contact],
                                      dealer_code: params[:dealer_trade][:dealer_code]
                                    )

    if params[:commit] == "Create And Print Trade Sheet"
      redirect_to dealer_trade_trade_sheet_path(@dealer_trade, format: :pdf) and return
    else
      redirect_to edit_dealer_trade_path(@dealer_trade) and return
    end
  end

  def edit
    @dealer_trade = current_user.dealership.dealer_trades.find(params[:id])
  end

  def update
    @dealer_trade = current_user.dealership.dealer_trades.find(params[:id])
    @dealer_trade.update(dealer_trade_params)
    
    if params[:commit] == "Print Trade Sheet"
      redirect_to dealer_trade_trade_sheet_path(@dealer_trade, format: :pdf) and return
    else
      redirect_to dealer_trades_path and return
    end
  end

  def destroy
    @dealer_trade = current_user.dealership.dealer_trades.find(params[:id])
    @dealer_trade.destroy
    redirect_to dealer_trades_path
  end

  def trade_sheet
    @dealer_trade = current_user.dealership.dealer_trades.find(params[:dealer_trade_id] )

    respond_to do |format|
     format.pdf do
       render pdf: "Trade Sheet - #{@dealer_trade.trade_dealer_name}",
       template: "dealer_trades/trade_sheet.html.haml",
       layout: 'pdf.html.erb'
     end
    end
  end

  def print_dealer_trade_sheet
    @dealer_trade = current_user.dealership.dealer_trades.find(params[:dealer_trade_id] )

    respond_to do |format|
     format.pdf do
       render pdf: "Sold Sheet",
       template: "dealer_trades/dealer_trade_printout_sheet.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end

  def stock_number_search
    @vehicle = current_user.dealership.vehicles.where("stock_number ILIKE ?", "#{params[:stock_number]}").last
  end

  def previous_trade_search
    @suggested_trade_dealerships = current_user.dealership.suggested_trade_dealerships.where("name ILIKE ? OR dealer_code ILIKE ?", "%#{params[:previous_trade_search]}%", "%#{params[:previous_trade_search]}%")
  end

  private
    def user_for_paper_trail
      current_user.full_name
    end

    def dealer_trade_params
      params.require(:dealer_trade).permit(
        :trade_dealer_name,
        :dealer_code,
        :trade_dealer_address,
        :trade_dealer_contact,
        :trade_contact_phone,
        :your_trade,
        :our_trade,
        :your_purchase,
        :our_purchase,
        :date_created,
        :time_created,
        :desk_manager,
        :model,
        :color,
        :year,
        :stock_number,
        :vin,
        :private_trade_notes,
        :delivered_invoice,
        :plus_deliver_acc,
        :less_rebate_1,
        :delivered_total,
        :trade_model,
        :trade_color,
        :trade_year,
        :trade_vin,
        :trade_stock_number,
        :received_invoice,
        :received_acc,
        :received_rebate,
        :received_sum,
        :public_trade_notes,
        :trade_difference,
        :trade_payment_type,
      )
    end
end