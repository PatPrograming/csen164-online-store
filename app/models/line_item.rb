class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    product.price * quantity
  end
end
