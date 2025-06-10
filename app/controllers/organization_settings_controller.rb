class OrganizationSettingsController < ApplicationController
  before_action :require_login

  def new
    redirect_to edit_organization_setting_path and return unless current_user.admin?
    @organization = Organization.new
  end

  def create
    unless current_user.admin?
      redirect_to edit_organization_setting_path and return
    end
    @organization = Organization.new(organization_params)
    if @organization.save
      current_user.update(organization: @organization)
      redirect_to tasks_path, notice: "組織を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    redirect_to new_organization_setting_path and return if current_user.admin?
  end

  def update
    unless current_user.supporter?
      redirect_to tasks_path and return
    end
    if params[:user].present? && current_user.update(user_organization_params)
      redirect_to tasks_path, notice: "組織を設定しました。"
    else
      flash.now[:alert] = "組織を選択してください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end

  def user_organization_params
    params.require(:user).permit(:organization_id)
  end

  def require_login
    redirect_to login_path, alert: "ログインしてください" unless user_signed_in?
  end
end
