class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:update, :destroy]

  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    line_item = current_cart.add_product(product, quantity)
    if line_item.save
      redirect_to cart_path, notice: "#{product.name} added to your cart."
    else
      redirect_to product_path(product), alert: "Could not add to cart."
    end
  end

  def update
    quantity = params[:quantity].to_i
    if quantity < 1
      @line_item.destroy
      redirect_to cart_path, notice: "Item removed."
    elsif @line_item.update(quantity: quantity)
      redirect_to cart_path, notice: "Cart updated."
    else
      redirect_to cart_path, alert: "Could not update item."
    end
  end

  def destroy
    @line_item.destroy
    redirect_to cart_path, notice: "Item removed."
  end

  private

  def set_line_item
    # Scope to the current cart so users can only modify their own cart items.
    @line_item = current_cart.line_items.find(params[:id])
  end
end
