class ApplicationsController < ApplicationController
  before_action :require_supporter
  before_action :set_task_from_params, only: %i[new create]
  before_action :set_application, only: %i[edit update]

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
    if @application.update(application_params)
      redirect_to @task, notice: "更新が完了しました。運営の返信をお待ちください"
    else
      render :edit, status: :unprocessable_entity
    end
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
end
