class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product, quantity = 1)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += quantity
    else
      current_item = line_items.build(product_id: product.id, quantity: quantity)
    end
    current_item
  end

  def total_price
    line_items.includes(:product).sum { |item| item.total_price }
  end

  def total_items
    line_items.sum(:quantity)
  end

  def empty?
    line_items.empty?
  end
end
