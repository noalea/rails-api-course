require 'rails_helper'

RSpec.describe Article, type: :model do
  it "tests a number to be positive" do
    expect(3).to be_positive()
    expect(3).to be > 0
  end
end
