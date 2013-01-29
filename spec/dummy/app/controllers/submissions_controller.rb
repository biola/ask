class SubmissionsController < ApplicationController
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
    @submission = Submission.new(params[:submission])
    @submission.form = @form
    if @submission.save
      redirect_to [@form, @submission]
    else
      render action: :new
    end
  end

end
