class StoreController < ApplicationController
  def index
    @query = params[:q]
    @products = Product.search(@query).order(:name)
  end
end
