class CheckoutsController < ApplicationController
  def create
    cart = params[:cart]

    begin
      session_url = Stripe::StripeCheckoutService.new(cart).create_checkout_session
      render json: { url: session_url }
    rescue ArgumentError => e
      render json: { error: e.message }, status: 400
    end
  end

  def success
    render :success
  end

  def cancel
    render :cancel
  end
end
