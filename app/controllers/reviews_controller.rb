class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_product
  before_action :set_review, only: [ :edit, :update, :destroy ]
  before_action :require_owner, only: [ :edit, :update, :destroy ]

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @product, notice: "Review posted."
    else
      @reviews = @product.reviews.includes(:user).order(created_at: :desc)
      @user_review = @product.reviews.find_by(user_id: current_user.id)
      render "products/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @product, notice: "Review updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to @product, notice: "Review deleted."
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def require_owner
    unless @review.user_id == current_user.id
      redirect_to @product, alert: "You can only manage your own reviews."
    end
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
