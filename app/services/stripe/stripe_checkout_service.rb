module Stripe
  class StripeCheckoutService
    def initialize(cart)
      @cart = cart
    end

    def create_checkout_session
      stripe_secret_key = Rails.application.config_for(:stripe)['secret_key']
      Stripe.api_key = stripe_secret_key

      line_items = build_line_items

      session = Stripe::Checkout::Session.create(
        mode: 'payment',
        line_items: line_items,
        success_url: 'http://localhost:3000/success',
        cancel_url: 'http://localhost:3000/cancel',
        shipping_address_collection: {
          allowed_countries: ['US', 'CA']
        }
      )

      session.url
    end

    private

    def build_line_items
      @cart.map do |item|
        product = ::Product.find(item['id'])
        product_stock = product.stocks.find { |ps| ps.size == item['size'] }

        if product_stock.amount < item['quantity'].to_i
          raise ArgumentError, "Not enough stock for #{product.name} in size #{item['size']}. Only #{product_stock.amount} left."
        end

        {
          quantity: item['quantity'].to_i,
          price_data: {
            product_data: {
              name: item['name'],
              metadata: { product_id: product.id, size: item['size'], product_stock_id: product_stock.id }
            },
            currency: 'usd',
            unit_amount: item['price'].to_i
          }
        }
      end
    end
  end
end
