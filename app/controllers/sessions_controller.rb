class SessionsController < ApplicationController
  include SessionsHelper

  def new; end

  def create
    # form_for tag creates params hash
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user

      # redirect_to user is traditional,
      #  but we'll go right to their schedule or reports for admin
      if current_user.admin
        redirect_back_or papers_path
      else
        redirect_back_or about_path
        # redirect_back_or events_path
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
