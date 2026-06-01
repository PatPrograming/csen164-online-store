class OrdersController < ApplicationController
  before_action :require_login
  before_action :set_order, only: [:show]

  def index
    @orders = if current_user.admin?
      Order.includes(:user).order(created_at: :desc)
    else
      current_user.orders.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    if current_cart.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end
    @order = Order.new(name: current_user.name)
  end

  def create
    @order = current_user.orders.build(order_params)

    if current_cart.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    cart = current_cart
    @order.add_line_items_from_cart(cart)

    if @order.save
      # The line items now belong to the order (cart_id is nil in the DB), but the
      # cart's in-memory line_items association still references them. Reset it before
      # destroying the cart so dependent: :destroy doesn't cascade and delete them.
      cart.line_items.reset
      cart.destroy
      session[:cart_id] = nil
      redirect_to @order, notice: "Thank you! Your order was placed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
    # Authorization: a user may only view their own order; admins may view any.
    unless current_user.admin? || @order.user_id == current_user.id
      redirect_to orders_path, alert: "You are not allowed to view that order."
    end
  end

  def order_params
    params.require(:order).permit(:name, :address)
  end
end
