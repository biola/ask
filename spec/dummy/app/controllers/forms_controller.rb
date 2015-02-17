class FormsController < ApplicationController

  def index
    @forms = Form.all
  end

  def show
    @form = Form.find(params[:id])
  end

  def new
    @form = Form.new
  end

  def edit
    @form = Form.find(params[:id])
  end

  def create
    @form = Form.new(form_params)

    if @form.save
      redirect_to @form, notice: 'Form was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @form = Form.find(params[:id])

    if @form.update_attributes(form_params)
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

  def form_params
    params.require(:form).permit(:title, {questions_attributes: [:id, :_destroy, :type, :name, :instructions, :required, :position, {choices_attributes: [:id, :_destroy, :name] }] })
  end

end
