class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :ensure_authenticated
  before_filter :hack_cucumber_request_format
  helper_method :current_user

  # cancan strong_params workaround
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    message = "You don't have permission to #{exception.action} that"

    if request.xhr?
      render json: {status: :error, errors: {"Error: " => message}}, status: 403
    else
      redirect_to root_url, alert: "Error: #{message}"
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    message = "You don't have permission to #{action_name} that"

    if request.xhr?
      render json: {status: :error, errors: {"Error: " => message}}, status: 403
    else
      redirect_to root_url, alert: "Error: #{message}"
    end
  end

  rescue_from ActiveRecord::UnknownAttributeError do |exception|
    message = "'#{exception.attribute}' is not a valid attribute"

    if request.xhr?
      render json: {status: :error, errors: {"Error: " => message}}, status: 403
    else
      redirect_to root_url, alert: "Error: #{message}"
    end
  end


  private

  def login(user)
    session[:user_id] = user.id
    @current_user = user
    @current_ability = Ability.new user
  end

  def hack_cucumber_request_format
    if Rails.env == 'test'
      if request.media_type == 'application/json'
        request.format = :json
      end
    end
  end

  def signed_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find session[:user_id] if signed_in?
  end

  def ensure_authenticated
    unless signed_in?
      render json: {status: :error, errors: {"Error: " => "You must be logged in to do that!"}}, status: 401
    end
  end
end
