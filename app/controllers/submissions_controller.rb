class SubmissionsController < ApplicationController

  filter_resource_access

  def index
    @form = Form.find(params[:form_id])
    @submissions = Submission.find_all_by_form_id(@form.try(:id))
  end

  def show
  end

  def new
    @submission.build_or_create_answers
  end

  def edit
    @submission.build_or_create_answers
  end

  def create
    
    @submission.form_id = params[:all_form_id]
    @submission.submitter = current_user # FIXME

    if @submission.save
      flash[:notice] = 'Submission received'
      redirect_to(@submission)
    else
      render :action => 'new'
    end
    
  end

  def update
    if @submission.update_attributes(params[:submission])
      flash[:notice] = 'Submission updated'
      redirect_to(@submission)
    else
      render :action => 'edit'
    end
  end
  
  protected
  
  # Override declarative_authorization's default load methods
  def new_submission_from_params
    @submission = Submission.new params[:submission]
    @submission.form_id = params[:form_id]
  end
  
  def load_submission
    @submission = Submission.find params[:id]
  end
  
end
