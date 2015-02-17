class SubmissionsController < ApplicationController

  def index
    @form = Form.find(params[:form_id])
    @submissions = @form.submissions
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def new
    @form = Form.find(params[:form_id])
    @submission = Submission.new
    @submission.build_or_create_answers @form.questions
  end

  def create
    @form = Form.find(params[:form_id])
    @submission = Submission.new(submission_params)
    @submission.form = @form
    if @submission.save
      redirect_to [@form, @submission]
    else
      @submission.build_or_create_answers @submission.form.questions
      render action: :new
    end
  end

  def edit
    @form = Form.find(params[:form_id])
    @submission = Submission.find(params[:id])
    @submission.build_or_create_answers @form.questions
  end

  def update
    @form = Form.find(params[:form_id])
    @submission = Submission.find(params[:id])
    if @submission.update_attributes(submission_params)
      flash[:notice] = 'Submission updated'
      redirect_to [@form, @submission]
    else
      @submission.build_or_create_answers @form.questions
      render action: :edit
    end
  end

  def destroy
    @form = Form.find(params[:form_id])
    @submission = Submission.find(params[:id])
    @submission.destroy

    redirect_to form_submissions_url(@form)
  end

  def submission_params
    begin
      params.require(:submission).permit(answers_attributes: [:question_id, :answer, :id])
    rescue ActionController::ParameterMissing
      {} # Submission may be empty. If so this will prevent it from erroring
    end
  end

end
