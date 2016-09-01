class PageController < ApplicationController
  def login
  	@user = session[:user]
  end

  def logout
  	@user = nil
  	reset_session
  	redirect_to root_path
  end
end
