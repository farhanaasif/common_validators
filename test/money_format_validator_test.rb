require 'test_helper'
require File.expand_path("../../app/validators/money_format_validator",  __FILE__)

class TestModel
  include ActiveModel::Validations
  attr_accessor :amount, :whole_amount

  validates :amount, money_format: true
  validates :whole_amount, money_format: { exclude_cents: true }
end

class MoneyFormatValidatorTest < ActiveSupport::TestCase
  def assert_valid_amount(amount, field = :amount)
    t = TestModel.new
    t.send(:"#{field}=", amount)
    assert t.valid?, "Amount `#{amount}` should be valid"
  end

  def assert_invalid_amount(amount, field = :amount)
    t = TestModel.new
    t.send(:"#{field}=", amount)
    assert !t.valid?, "Amount `#{amount}` should be invalid"
  end

  test "invalid amount" do
    assert_invalid_amount "a"
    assert_invalid_amount "10 20"
    assert_invalid_amount "10.123"
    assert_invalid_amount "1,000.12"

    assert_invalid_amount "100.99", :whole_amount
    assert_invalid_amount "100.1", :whole_amount
  end

  test "valid amount" do
    assert_valid_amount ""
    assert_valid_amount "1"
    assert_valid_amount "1.00"
    assert_valid_amount "1.99"
    assert_valid_amount "+1.99"
    assert_valid_amount "-1.99"
    assert_valid_amount "100000.99"
    assert_valid_amount "100000.99"

    assert_valid_amount "100.00", :whole_amount
  end
end
