module Webhooks
  class PaymentsController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def create
      @stripe_customer_id = params['data']['object']['customer']
      @stripe_charge_id = params['data']['object']['charge']
      @amount_in_cents = params['data']['object']['amount_paid']

      @dealership = Dealership.find_by(stripe_customer_id: @stripe_customer_id)

      if @dealership.present?
        @dealership.update(most_recent_payment_received_at: DateTime.now)
      else
        raise "Unable to find dealership for customer: #{@stripe_customer_id}, charge: #{@stripe_charge_id}"
      end

      head :ok
    end

  end
end