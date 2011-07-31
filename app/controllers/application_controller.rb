class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged?
   redirect_to "/auth/facebook" if !session[:id]
  end
end
