class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

  def cart
    @cart ||= cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
  end
  helper_method :cart

  def enhanced_cart
    @enhanced_cart ||= Product.where(id: cart.keys).map {|product| { product:product, quantity: cart[product.id.to_s] } }
  end
  helper_method :enhanced_cart

  def cart_subtotal_cents
    enhanced_cart.map {|entry| entry[:product].price_cents * entry[:quantity]}.sum
  end
  helper_method :cart_subtotal_cents


  def update_cart(new_cart)
    cookies[:cart] = {
      value: JSON.generate(new_cart),
      expires: 10.days.from_now
    }
    cookies[:cart]
  end

  def line_items
    @line_items ||= Product
    .select("products.id, products.image, products.name, products.description, line_items.quantity, products.price_cents, orders.email")
    .joins("JOIN line_items ON line_items.product_id = products.id")
    .joins("JOIN orders ON order_id = orders.id")
    .where("line_items.order_id = #{@order.id}")
    .map {|product| { product:product } }
  end
  helper_method :line_items

  def order_subtotal_cents
    line_items.map {|entry| entry[:product].price_cents * entry[:product].quantity}.sum
  end
  helper_method :order_subtotal_cents

end
