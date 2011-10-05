require 'test_helper'

class FormsControllerTest < ActionController::TestCase
  setup do
    @form = forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create form" do
    assert_difference('Form.count') do
      post :create, form: @form.attributes
    end

    assert_redirected_to form_path(assigns(:form))
  end

  test "should show form" do
    get :show, id: @form.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @form.to_param
    assert_response :success
  end

  test "should update form" do
    put :update, id: @form.to_param, form: @form.attributes
    assert_redirected_to form_path(assigns(:form))
  end

  test "should destroy form" do
    assert_difference('Form.count', -1) do
      delete :destroy, id: @form.to_param
    end

    assert_redirected_to forms_path
  end
end
