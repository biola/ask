class FormsController < ApplicationController

  filter_resource_access if respond_to? :filter_resource_access

  def show
    render 'forms/show'
  end

  def new
    build_questions_and_choices
  end

  def edit
    if @form.questions.count > 0
      # Don't add a blank question if there are already questions saved
      @form.questions.each{ |q| q.choices.build }
    else
      build_questions_and_choices
    end
    
    render 'forms/edit'
  end

  def create
    if @form.save
      flash[:notice] = 'Form created'
      redirect_to(@form)
    else
      build_questions_and_choices if @form.questions.empty?
      render('forms/new')
    end
  end

  def update
    if @form.update_attributes(params[:form])
      flash[:notice] = 'Form updated'
      redirect_to(@form)
    else
      render('forms/edit')
    end
  end

  def destroy
    @form.destroy
    flash[:info] = 'Form deleted'
    redirect_to(forms_path)
  end
  
  private
  
  def build_questions_and_choices
    @form.questions.build
    @form.questions.each{|q| q.choices.build }
  end
  
end
