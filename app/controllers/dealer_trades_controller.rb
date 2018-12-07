class DealerTradesController < ApplicationController

  def index
    @dealer_trades = current_user.dealership.dealer_trades
  end

  def new
  end

  def create
    @dealer_trade = current_user.dealership.dealer_trades.create(dealer_trade_params)

    redirect_to dealer_trades_path 
  end



  private
    def dealer_trade_params
      params.require(:dealer_trade).permit(
        :trade_dealer_name,
        :trade_dealer_address,
        :trade_dealer_contact,
        :trade_contact_phone,
        :your_trade,
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