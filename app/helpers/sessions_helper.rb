module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token

    cookies.permanent[:remember_token] = remember_token
    # same as:
    #  cookies[:remember_token] = { value: remember_token, expires: 2.weeks.from_now.utc }

    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    # First, change the token in the db in case the cookie is stolen to be used later (an attack)
    current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))

    # Now delete the cookie and set the user to nil...
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    #  This re-searches on each new page find... otherwise current user becomes nil
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
