require 'test_helper'

class VolvosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volvo = volvos(:one)
  end

  test "should get index" do
    get volvos_url
    assert_response :success
  end

  test "should get new" do
    get new_volvo_url
    assert_response :success
  end

  test "should create volvo" do
    assert_difference('Volvo.count') do
      post volvos_url, params: { volvo: { position: @volvo.position, registration_number: @volvo.registration_number, vehicle_id: @volvo.vehicle_id, vin: @volvo.vin } }
    end

    assert_redirected_to volvo_url(Volvo.last)
  end

  test "should show volvo" do
    get volvo_url(@volvo)
    assert_response :success
  end

  test "should get edit" do
    get edit_volvo_url(@volvo)
    assert_response :success
  end

  test "should update volvo" do
    patch volvo_url(@volvo), params: { volvo: { position: @volvo.position, registration_number: @volvo.registration_number, vehicle_id: @volvo.vehicle_id, vin: @volvo.vin } }
    assert_redirected_to volvo_url(@volvo)
  end

  test "should destroy volvo" do
    assert_difference('Volvo.count', -1) do
      delete volvo_url(@volvo)
    end

    assert_redirected_to volvos_url
  end
end
