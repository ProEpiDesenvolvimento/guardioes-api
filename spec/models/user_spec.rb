require 'rails_helper'
require 'spec_helper'

def test_user_count(expected)
  expect(User.all.length).to eq(expected)
end

#################################################
## Some tests r not suposed to be in this file ##
#################################################
RSpec.describe User, type: :model do

  let(:app) { FactoryBot.create(:app) }

  let(:valid_attributes) do
    {
      user_name: "TestUser",
      email: "test@example.com",
      password: "Test@1234",
      birthdate: Date.new(1990, 1, 1),
      country: "Brasil",
      app: app
    }
  end

  describe "password validations" do
    context "valid password" do
      it "accepts a password with uppercase, lowercase, digit and special character" do
        user = User.new(valid_attributes)
        expect(user.valid?).to be true
      end
    end

    context "invalid password" do
      it "rejects a password shorter than 8 characters" do
        user = User.new(valid_attributes.merge(password: "Ab@1"))
        user.valid?
        expect(user.errors[:password]).not_to be_empty
      end

      it "rejects a password without uppercase letter" do
        user = User.new(valid_attributes.merge(password: "test@1234"))
        user.valid?
        expect(user.errors[:password]).not_to be_empty
      end

      it "rejects a password without lowercase letter" do
        user = User.new(valid_attributes.merge(password: "TEST@1234"))
        user.valid?
        expect(user.errors[:password]).not_to be_empty
      end

      it "rejects a password without digit" do
        user = User.new(valid_attributes.merge(password: "Test@abcd"))
        user.valid?
        expect(user.errors[:password]).not_to be_empty
      end

      it "rejects a password without special character" do
        user = User.new(valid_attributes.merge(password: "Test12345"))
        user.valid?
        expect(user.errors[:password]).not_to be_empty
      end

      it "rejects a blank password" do
        user = User.new(valid_attributes.merge(password: ""))
        user.valid?
        expect(user.errors[:password]).not_to be_empty
      end
    end
  end

end
