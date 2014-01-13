require 'spec_helper'

describe SubmissionsController do

  before(:each) do
    @submission = create(:submission_with_answers)
    @form = @submission.form
  end

  describe 'GET #index' do
    it "renders the :index view" do
      get :index, form_id: @form
      expect(response).to render_template :index
    end
    it "shows a list of submissions" do
      get :index, form_id: @form
      expect(assigns(:submissions).length).to be > 0
    end
  end

  describe 'GET #show' do
    it "renders the :show template" do
      get :show, id: @submission, form_id: @form
      expect(response).to render_template :show
    end
    it "returns the appropriate submission" do
      get :show, id: @submission, form_id: @form
      expect(assigns(:submission)).to eql @submission
    end
  end

  describe 'GET #new' do
    it "renders the :new template" do
      get :new, form_id: @form
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "renders the :edit template" do
      get :edit, id: @submission, form_id: @form
      expect(response).to render_template :edit
    end
    it "assigns the requested submission to @submission" do
      get :edit, id: @submission, form_id: @form
      expect(assigns(:submission)).to eql @submission
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new submission in the database" do
        expect{
          post :create, form_id: @form, submission: attributes_for(:submission_with_answers)
        }.to change(Submission, :count).by(1)
      end
      it "redirects to the home page" do
        post :create, form_id: @form, submission: attributes_for(:submission_with_answers)
        expect(response).to redirect_to [@form, Submission.last]
      end
    end
    # context "with invalid attributes" do
    #   it "does not save the new submission in the database" do
    #     expect{
    #       post :create, form_id: @form, submission: attributes_for(:submission, title: nil)
    #     }.to change(Submission, :count).by(0)
    #   end
    #   it "re-renders the :new template" do
    #     post :create, form_id: @form, submission: attributes_for(:submission, title: nil)
    #     expect(response).to render_template :new
    #   end
    # end
  end
  describe 'PUT #update' do
    context "with valid attributes" do
      before(:each) do
        @answer_to_update = @submission.answers.first
        @submission_attributes = {"answers_attributes"=>{"0"=>{"question_id"=>@answer_to_update.question.id, "answer"=>"this is the new answer", "id"=>@answer_to_update.id}}}
      end
      it "locates the requested @submission" do
        put :update, id: @submission, form_id: @form, submission: @submission_attributes
        expect(assigns(:submission)).to eql @submission
      end
      it "updates the submission in the database" do
        expect{
          put :update, id: @submission, form_id: @form, submission: @submission_attributes
          @answer_to_update.reload
        }.to change(@answer_to_update, :answer)
        expect(@answer_to_update.answer).to eql "this is the new answer"
      end
      it "redirects to the submission" do
        put :update, id: @submission, form_id: @form, submission: @submission_attributes
        expect(response).to redirect_to [@form, @submission]
      end
    end
    context "with invalid attributes" do
      before(:each) do
        @answer_to_update = @submission.answers.first
        question = @answer_to_update.question
        question.required = true
        question.save
        @submission_attributes = {"answers_attributes"=>{"0"=>{"question_id"=>@answer_to_update.question.id, "answer"=>nil, "id"=>@answer_to_update.id}}}
      end
      it "does not update the submission" do
        expect{
          put :update, id: @submission, form_id: @form, submission: @submission_attributes
          @answer_to_update.reload
        }.to_not change(@answer_to_update, :answer)
        expect(@answer_to_update.answer).not_to eql nil
      end
      it "re-renders the #edit template" do
        put :update, id: @submission, form_id: @form, submission: @submission_attributes
        expect(response).to render_template :edit
      end
      it "throws a Mass Assignment error if trying to update questions" do
        @question = @answer_to_update.question
        question_attributes = {"questions_attributes"=>{"0"=>{"id"=>@question.id, "name"=>"What is blue?"}}}
        expect{
          put :update, id: @submission, form_id: @form, submission: question_attributes
          @answer_to_update.reload
        }.to raise_error
        expect(@question.name).not_to eql "What is blue?"
      end
    end
  end
  describe 'DELETE #destroy' do
    it "deletes the submission from the database" do
      expect{
        delete :destroy, id: @submission, form_id: @form
      }.to change(Submission, :count).by(-1)
    end
    it "redirects to the submissions index" do
      delete :destroy, id: @submission, form_id: @form
      expect(response).to redirect_to form_submissions_url(@form)
    end
  end
end