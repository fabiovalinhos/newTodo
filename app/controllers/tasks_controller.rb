class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    # @tasks = Task.order(due_date: :desc)
    @tasks = Task.only_parent.order(due_date: :desc)
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'Tarefa criada com sucesso.'
    else
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: 'Tarefa atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @task }
      else
        flash.now[:alert] = @task.errors.full_messages.to_sentence
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Tarefa removida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :due_date, :done, :parent_id)
  end
end
