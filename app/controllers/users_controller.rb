class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where('id != 1').paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Headsets Data Entry App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # Taken care of by sessions helper correct_user
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :txtupdate,
                                 :alert,
                                 :alerttime,
                                 performances_attributes: [:id,
                                                           :name])
  end

  # Before_action functions

  def signed_in_user
    redirect_to signin_url, notice: 'Please sign in.' unless signed_in?
  end

  def correct_user
    # this allows only a user or admin to get at the edit screen
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || current_user.admin
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
