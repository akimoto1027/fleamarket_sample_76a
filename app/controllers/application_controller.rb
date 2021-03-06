class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :set_category
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
  
  def index
  end

  protected

  def set_category
    @category_parent_array = []
      Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent
      end
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:basic_auth][:user] &&
      password == Rails.application.credentials[:basic_auth][:pass]
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname,:family_name, :first_name, :family_name_kana, :first_name_kana, :year, :month, :day, :phone_number, :gender])
  end

  def set_search
    @search = Item.ransack(params[:q])
    @items = @search.result(distinct: true)
  end
end