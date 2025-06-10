class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(mail_address: params[:session][:mail_address])
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to main_app.tasks_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to main_app.tasks_path, notice: "Logged out"
  end
end
