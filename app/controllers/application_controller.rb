class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :current_cart

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Please log in to continue."
    end
  end

  def require_admin
    unless logged_in? && current_user.admin?
      redirect_to root_path, alert: "Admins only."
    end
  end

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id]
    cart ||= Cart.create
    session[:cart_id] = cart.id
    cart
  end
end
