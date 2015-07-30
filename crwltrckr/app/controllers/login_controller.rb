class LoginController < ApplicationController
	def index
	end
	def authenticate
		redirect_to root_path
	end
end
