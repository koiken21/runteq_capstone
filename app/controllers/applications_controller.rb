class ApplicationsController < ApplicationController
  before_action :set_task_from_params, only: %i[new create]
  before_action :set_application, only: %i[edit update show]
  before_action :require_supporter, only: %i[new create]
  before_action :require_owner, only: %i[show]
  before_action :require_admin_or_owner, only: %i[edit update]

  def new
    @application = @task.applications.build
    @application.application_status = "応募"
  end

  def create
    @application = @task.applications.build(application_params)
    @application.supporter = current_user
    @application.application_status = "応募"
    if @application.save
      redirect_to @task, notice: "応募が完了しました。運営の返信をお待ちください"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = @application.task
  end

  def update
    @task = @application.task
    if current_user.admin?
      if @application.update(admin_application_params)
        redirect_to @task, notice: "返信が完了しました。サポーターの返信をお待ちください"
      else
        flash.now[:alert] = "返信に失敗しました、お手数ですが再度返信を試みてください"
        render :edit, status: :unprocessable_entity
      end
    else
      if @application.update(supporter_application_params)
        msg = if supporter_application_params[:request_status] == '受諾'
                '受諾が完了しました。'
              elsif supporter_application_params[:request_status] == '辞退'
                '辞退が完了しました。'
              else
                '更新が完了しました。運営の返信をお待ちください'
              end
        redirect_to @task, notice: msg
      else
        flash.now[:alert] = '返信に失敗しました、お手数ですが再度返信を試みてください'
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def show
    @task = @application.task
  end

  private

  def require_supporter
    redirect_to tasks_path unless current_user&.supporter?
  end

  def set_task_from_params
    @task = Task.find(params[:task_id])
  end

  def set_application
    @application = Application.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:application_status, :experience, :uptime, :comment_supporter)
  end

  def supporter_application_params
    params.require(:application).permit(:application_status, :experience, :uptime, :comment_supporter, :request_status)
  end

  def admin_application_params
    params.require(:application).permit(:request_status, :comment_organization)
  end

  def require_owner
    unless current_user&.supporter? && @application.supporter == current_user
      redirect_to tasks_path
    end
  end

  def require_admin_or_owner
    return if current_user&.admin?
    require_owner
  end
end
