class CartsController < ApplicationController
  def show
    @cart = current_cart
  end

  def destroy
    current_cart.line_items.destroy_all
    redirect_to cart_path, notice: "Cart emptied."
  end
end
