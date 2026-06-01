class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :line_items, dependent: :destroy

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true

  scope :search, ->(query) {
    if query.present?
      where("name LIKE :q OR description LIKE :q", q: "%#{query}%")
    else
      all
    end
  }

  def average_rating
    reviews.average(:rating)&.round(1)
  end

  def reviews_count
    reviews.size
  end

  private

  def ensure_not_referenced_by_any_line_item
    # Only block deletion if the product is part of a placed order.
    if line_items.where.not(order_id: nil).exists?
      errors.add(:base, "cannot delete product that belongs to an order")
      throw :abort
    end
  end
end
