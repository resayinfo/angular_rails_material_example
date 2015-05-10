class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_filter :ensure_authenticated

  # POST /sessions
  def create
    if params[:username]
      user   = User.find_by_downcased_username params[:username].downcase
      user ||= User.find_by_email params[:username].downcase
    end

    if user && user.active && user.authenticate(params[:password])
      login(user)
      render json: { user: user }
    end
  end

  # DELETE /sessions/1
  def destroy
    session[:user_id] = nil
  end
end
