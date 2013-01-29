class FormsController < ApplicationController

  def index
    @forms = Form.all
  end

  def show
    @form = Form.find(params[:id])
  end

  def new
    @form = Form.new
    build_questions
  end

  def edit
    @form = Form.find(params[:id])
    build_questions
  end

  def create
    @form = Form.new(params[:form])

    if @form.save
      redirect_to @form, notice: 'Form was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @form = Form.find(params[:id])

    if @form.update_attributes(params[:form])
      redirect_to @form, notice: 'Form was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @form = Form.find(params[:id])
    @form.destroy

    redirect_to forms_url
  end

  private

  def build_questions
    @form.questions.build
    @form.questions.each{|q| q.choices.build}
  end
end
