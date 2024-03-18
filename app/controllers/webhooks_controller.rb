class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.config_for(:stripe)['webhook_secret']

    begin
      Stripe::StripeWebhookService.new(payload, sig_header, endpoint_secret).process_webhook_event
    rescue ArgumentError => e
      puts e.message
      render json: { error: e.message }, status: 400
    end

    render json: { message: 'success' }
  end
end
