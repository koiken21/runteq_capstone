class UsersController < ApplicationController
  before_action :set_user_by_token, only: [:complete_registration]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.organization_id = Organization.first.id
    initial_password = SecureRandom.base58(8)
    @user.password = initial_password
    if @user.save
      @user.generate_registration_token!
      UserMailer.registration_email(@user, initial_password).deliver_now
      redirect_to root_path, notice: 'Registration email sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def complete_registration
    if request.patch?
      unless @user && @user.registration_token_valid?
        redirect_to root_path, alert: 'Invalid token' and return
      end
      unless @user.authenticate(params[:user][:initial_password])
        flash.now[:alert] = 'Initial password is incorrect'
        render :complete_registration, status: :unprocessable_entity and return
      end
      if @user.update(complete_user_params)
        @user.clear_registration_token!
        redirect_to root_path, notice: 'Registration completed.'
      else
        render :complete_registration, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    permitted = params.require(:user).permit(:mail_address)
    role = params[:user][:role]
    if role.present? && role.in?(User::ROLES)
      permitted[:role] = role
    end
    permitted
  end

  def complete_user_params
    params.require(:user).permit(:mail_address, :name, :password, :password_confirmation)
  end

  def set_user_by_token
    @user = User.find_by(registration_token: params[:token])
  end
end
