class ApplicationController < ActionController::API
	def current_user
		if request.headers['Authorization'].present?
			user = User.where(:auth_token => request.headers['Authorization'])
			if user && user.auth_expiry_time < Time.now
				user
			else
				render json: {error: "Login again"}, status: 407
			end
				
		end
	end
end
