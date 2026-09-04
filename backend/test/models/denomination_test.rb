require "test_helper"

class DenominationTest < ActiveSupport::TestCase
  test "valid with a unique name" do
    denomination = Denomination.new(name: "Catholic")
    assert denomination.valid?
  end

  test "invalid with a duplicate name" do
    Denomination.create!(name: "Catholic")
    dup = Denomination.new(name: "Catholic")
    assert_not dup.valid?
  end
end