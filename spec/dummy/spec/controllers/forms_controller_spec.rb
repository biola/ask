require 'spec_helper'

describe FormsController, type: :controller do
  describe 'GET #index' do
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
    it "shows a list of forms" do
      create(:form)
      get :index
      expect(assigns(:forms).length).to be > 0
    end
  end

  describe 'GET #show' do
    it "renders the :show template" do
      get :show, id: create(:form)
      expect(response).to render_template :show
    end
    it "returns the appropriate form" do
      form = create(:form)
      get :show, id: form
      expect(assigns(:form)).to eql form
    end
  end

  describe 'GET #new' do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "renders the :edit template" do
      get :edit, id: create(:form)
      expect(response).to render_template :edit
    end
    it "assigns the requested form to @form" do
      form = create(:form)
      get :edit, id: form
      expect(assigns(:form)).to eql form
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new form in the database" do
        expect{
          post :create, form: attributes_for(:form_with_questions)
        }.to change(Form, :count).by(1)
      end
      it "redirects to the home page" do
        post :create, form: attributes_for(:form_with_questions)
        expect(response).to redirect_to Form.last
      end
    end
    context "with invalid attributes" do
      it "does not save the new form in the database" do
        expect{
          post :create, form: attributes_for(:form, title: nil)
        }.to change(Form, :count).by(0)
      end
      it "re-renders the :new template" do
        post :create, form: attributes_for(:form, title: nil)
        expect(response).to render_template :new
      end
    end
  end
  describe 'PUT #update' do
    before :each do
      @form = create(:form)
    end
    context "with valid attributes" do
      it "locates the requested @form" do
        put :update, id: @form, form: attributes_for(:form, title: "New Title")
        expect(assigns(:form)).to eql @form
      end
      it "updates the form in the database" do
        put :update, id: @form, form: attributes_for(:form, title: "New Title")
        @form.reload
        expect(@form.title).to eql "New Title"
      end
      it "redirects to the form" do
        put :update, id: @form, form: attributes_for(:form, title: "New Title")
        expect(response).to redirect_to @form
      end
    end
    context "with invalid attributes" do
      it "does not update the form" do
        put :update, id: @form, form: attributes_for(:form, title: nil)
        @form.reload
        expect(@form.title).not_to eql nil
      end
      it "re-renders the #edit template" do
        put :update, id: @form, form: attributes_for(:form, title: nil)
        expect(response).to render_template :edit
      end
    end
  end
  describe 'DELETE #destroy' do
    before :each do
      @form = create(:form)
    end
    it "deletes the form from the database" do
      expect{
        delete :destroy, id: @form
      }.to change(Form, :count).by(-1)
    end
    it "redirects to the forms index" do
      delete :destroy, id: @form
      expect(response).to redirect_to forms_url
    end
  end
end
