require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url, params: { account: { accountId: @account.accountId, accountName: @account.accountName, accountType: @account.accountType, addAccountDateInDate: @account.addAccountDateInDate, closeDateInDate: @account.closeDateInDate, currency: @account.currency, currentBalance: @account.currentBalance, dueAmt: @account.dueAmt, dueDate: @account.dueDate, fiLoginStatus: @account.fiLoginStatus, fiName: @account.fiName, interestRate: @account.interestRate, isActive: @account.isActive, isClosed: @account.isClosed, isError: @account.isError, lastUpdatedInDate: @account.lastUpdatedInDate, status: @account.status, value: @account.value, yodleeAccountNumberLastFour: @account.yodleeAccountNumberLastFour } }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should show account" do
    get account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    patch account_url(@account), params: { account: { accountId: @account.accountId, accountName: @account.accountName, accountType: @account.accountType, addAccountDateInDate: @account.addAccountDateInDate, closeDateInDate: @account.closeDateInDate, currency: @account.currency, currentBalance: @account.currentBalance, dueAmt: @account.dueAmt, dueDate: @account.dueDate, fiLoginStatus: @account.fiLoginStatus, fiName: @account.fiName, interestRate: @account.interestRate, isActive: @account.isActive, isClosed: @account.isClosed, isError: @account.isError, lastUpdatedInDate: @account.lastUpdatedInDate, status: @account.status, value: @account.value, yodleeAccountNumberLastFour: @account.yodleeAccountNumberLastFour } }
    assert_redirected_to account_url(@account)
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end
end
