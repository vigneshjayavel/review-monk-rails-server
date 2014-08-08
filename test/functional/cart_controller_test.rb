require 'test_helper'

class CartControllerTest < ActionController::TestCase
  test "should get review_order" do
    get :review_order
    assert_response :success
  end

  test "should get payment" do
    get :payment
    assert_response :success
  end

end
