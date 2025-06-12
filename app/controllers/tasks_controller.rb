class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if user_signed_in?
      @tasks = Task.where(organization_id: current_user.organization_id)
      @tasks = @tasks.where(status: %w[募集中 募集終了]) if current_user.supporter?
    else
      @tasks = Task.all
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully destroyed."
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :apply_deadline, :required_number_of_people, :status, :organization_id)
  end
end
