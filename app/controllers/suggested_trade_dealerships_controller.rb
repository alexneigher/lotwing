class SuggestedTradeDealershipsController < ApplicationController

  def destroy
    @suggested_trade_dealership = current_user.dealership.suggested_trade_dealerships.find(params[:id])

    @suggested_trade_dealership.destroy
  end
end