class ProductsController < ApplicationController
  before_action :require_admin, except: [ :show ]
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def show
    @reviews = @product.reviews.includes(:user).order(created_at: :desc)
    @review = Review.new
    if logged_in?
      @user_review = @product.reviews.find_by(user_id: current_user.id)
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      redirect_to root_path, notice: "Product deleted."
    else
      redirect_to @product, alert: @product.errors.full_messages.to_sentence
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :image_url)
  end
end
