class DealerTradesController < ApplicationController

  def index
    @dealer_trades = current_user.dealership.dealer_trades
  end

  def new
  end
end