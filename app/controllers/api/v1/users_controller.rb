class Api::V1::UsersController < Api::V1::ApiController
  skip_before_filter :ensure_authenticated, only: [:new, :create, :show, :index]
  before_filter :filter_user_params
  load_and_authorize_resource except: :index


  # GET /users
  # GET /users.json
  def index
    authorize! :index, Post
    @users = UsersQueryFilter.new(params, current_ability).run_query
  end

  # GET /users/new
  def new
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end


  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    if @user.save
      render json: {user: @user}, status: :created
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1.json
  def update
    if @user.update_attributes(user_params)
      render json: {user: @user}, status: :no_content
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.deactivate!
    head :no_content
  end


  private

  def user_params
    return nil if params[:user].blank?
    params.require(:user).permit(
      *filtered_params,
      *password_params,
      :id,
      :first_name,
      :middle_name,
      :last_name,
      :username,
      :email,
      :created_at,
      :updated_at
    )
  end

  def filtered_params
    [:admin, :deactivated_at]
  end

  def password_params
    [:password, :password_confirmation]
  end

  def filter_user_params
    return nil if params[:user].blank?

    unless current_user.try :admin?
      params[:user].except! *filtered_params
    end

    unless params[:user][:password].present?
      params[:user].except! *password_params
    end
  end
end