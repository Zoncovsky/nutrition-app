module Stripe
  class StripeWebhookService
    def initialize(payload, sig_header, endpoint_secret)
      @payload = payload
      @sig_header = sig_header
      @endpoint_secret = endpoint_secret
    end

    def process_webhook_event
      event = construct_event
      handle_event(event)
    end

    private

    def construct_event
      Stripe::Webhook.construct_event(@payload, @sig_header, @endpoint_secret)
    rescue JSON::ParserError => e
      raise ArgumentError, 'Invalid payload'
    rescue Stripe::SignatureVerificationError => e
      raise ArgumentError, 'Invalid signature'
    end

    def handle_event(event)
      case event.type 
      when 'checkout.session.completed'
        handle_checkout_completed(event)
      else
        puts "Unhandled event type: #{event.type}"
      end
    end

    def handle_checkout_completed(event)
      session = event.data.object 
      shipping_details = session['shipping_details']
      address = shipping_details ? "#{shipping_details['address']['line1']} #{shipping_details['address']['city']}, #{shipping_details['address']['state']} #{shipping_details['address']['postal_code']}" : ''

      order = create_order(session, address)
      create_order_products(session, order)
    end

    def create_order(session, address)
      Order.create!(
        customer_email: session['customer_details']['email'],
        total: session['amount_total'],
        address: address,
        fulfilled: false
      )
    end

    def create_order_products(session, order)
      full_session = Stripe::Checkout::Session.retrieve({
        id: session.id,
        expand: ['line_items']
      })
      line_items = full_session.line_items
      line_items['data'].each do |item|
        product = Stripe::Product.retrieve(item['price']['product'])
        product_id = product['metadata']['product_id'].to_i
        OrderProduct.create!(
          order: order,
          product_id: product_id,
          quantity: item['quantity'],
          size: product['metadata']['size']
        )
        Stock.find(product['metadata']['product_stock_id']).decrement!(:amount, item['quantity'])
      end
    end
  end
end
