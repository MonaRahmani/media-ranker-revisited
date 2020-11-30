class UsersController < ApplicationController
  before_action :require_login, only: [:index, :show]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end


  def create

    auth_hash = request.env["omniauth.auth"]
    # binding.pry
    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
    if user
      flash[:success] = "Logged in as returning user #{user.username}"
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.username}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    redirect_to root_path
  end

  def logout
    if @login_user
      session[:user_id] = nil
      flash[:notice] = "Successfully logged out"

      redirect_to root_path
      return
    else
      flash[:warning] = "You were not logged in!"

      redirect_to root_path
      return
    end
  end
end
