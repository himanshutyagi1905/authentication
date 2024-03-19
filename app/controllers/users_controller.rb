class UsersController < ApplicationController
 # before_action :authorize_request, except: :create
  #before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    @user = User.find(params[:id])
    render json: @user, status: :ok
  end
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    @user = User.find_by_id(params[:id])
    if @user
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "User not found" }, status: :not_found
    end 
  end





  # DELETE /users/{username}
  def destroy
    @user = User.find_by(id: params[:id])
    if @user
      @user.destroy
      head :no_content
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
  
  private

  def find_user
    @user = User.find_by_username(params[:username])
    render json: { errors: 'User not found' }, status: :not_found unless @user
  end

  
  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end
end
