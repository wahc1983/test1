require 'test_helper'

class AuthensControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_create_invalid
    Authen.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Authen.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to authens_url
  end

  def test_destroy
    authen = Authen.first
    delete :destroy, :id => authen
    assert_redirected_to authens_url
    assert !Authen.exists?(authen.id)
  end
end
