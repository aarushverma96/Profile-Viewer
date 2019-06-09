class UsersController < ApplicationController

  def index
    users = User.all
    render json: users, status: 200
  end

  def login
    user_password = params[:password]
    user_email = params[:email]
    # checks email and password to authenticate user
    if (user = User.find_by(email: user_email).try(:authenticate, user_password))
      # generate tokens only if temp_password is not present
      user.generate_auth_token
      render json: user, status: 200
    else
      render json: {error: "Incorrect user id or password"}, status: 422
    end
  end


  def show1
    if $cache_redis.get(request.headers["Authorization"]) != nil
      render json: $cache_redis.get(request.headers["Authorization"]), status: 200
    else
      user = User.find_by(:auth_token => request.headers['Authorization'])
      if user && user.auth_expiry_time < Time.now
        $cache_redis.set(request.headers["Authorization"], user.as_json, options = {:ex => (Time.now()-user.auth_expiry_time).seconds})
        render json: user 
      else
        render json: {error: "Login again"}, status: 407
      end
    end  
  end

  def create
    user = User.new(user_params)
    user.company = Company.find(params['company_id'])
    user.password = params['password']

    if user.save
      render json: user, status: 200
    else
      render json: user.errors, status: 422
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :job_role, :email, :password)
    end
end
