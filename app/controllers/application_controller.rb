class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This module is available to views and controllers, crossing the MVC architecture
  #  By default these helpers are available in views, but must add it to make it available in controllers
  include ApplicationHelper
  include SessionsHelper

  def weekstart
    astart = DateTime.now.utc.beginning_of_day
    loop do
      break if astart.wday == 1
      astart -= 1.day
    end
    astart
  end

end
