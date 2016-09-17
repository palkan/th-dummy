class AnswersController < ApplicationController
  include Voted

  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :best]

  def create
    authorize Answer
    @answer = @question.answers.create(
      answer_params.merge(user: current_user)
    )
    render_json @answer
  end

  def destroy
    @answer.destroy
    render_json_message
  end

  def update
    @answer.update(answer_params)
    render_json @answer
  end

  def best
    @answer.make_best
    render_json @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end
end
