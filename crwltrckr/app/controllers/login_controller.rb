class LoginController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :require_login, :only => [:landing, :connect, :create]
	def index
	end
	def go_to_dashboard
		redirect_to root_path
	end
end
