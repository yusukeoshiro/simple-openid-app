class PageController < ApplicationController
  def login
  	@community_url = "https://#{ENV['SALESFORCE_HOST']}"
  	if session[:user_id].present?
  		@user = User.find(session[:user_id])
  	end
  	


  end

  def logout
  	@user = nil
  	reset_session
  	redirect_to root_path
  end
end
