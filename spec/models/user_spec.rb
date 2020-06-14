require 'rails_helper'
require 'spec_helper'

def test_user_count(expected)
  expect(User.all.length).to eq(expected)
end

RSpec.describe User, type: :model do

  before :all do
    App.new(:app_name=>"cleber institution", :owner_country=>"brazil").save()
  end

  let (:valid_user) {
    User.new(
      :user_name => "Clebin",
      :email => "clebinlolo@business.com",
      :password => "12369420",
      :app_id => 1
    )
  }

  describe "basic user model functions" do
    context "valid input" do
      it "creates valid user" do
        expect(valid_user.save()).to be true
      end
      it "deletes user" do
        valid_user.save()
        test_user_count(1)
        User.all[0].delete()
        test_user_count(0)
      end
      it "updates user" do
        valid_user.save()
        expect(User.all[0].user_name).to eq(valid_user.user_name)
        valid_user.update(:user_name=>"Clebao")
        expect(User.all[0].user_name).to eq("Clebao")
      end
    end
    context "invalid input" do
      it "fails to update with invalid fields" do
        valid_user.save()
        User.all[0].update(:user_name=>"Clebao", :app_id=>2)
        expect(User.all[0].app_id).to eq(valid_user.app_id)
        expect(User.all[0].user_name).to eq(valid_user.user_name)
      end
      it "fails to create user not tied to any app" do
        invalid_user = valid_user
        invalid_user.app_id = 2
        invalid_user.save()
        test_user_count(0)
      end
      it "fails to create user with same email as other user" do
        valid_user.save()
        invalid_user = valid_user
        invalid_user.user_name = "vitin"
        invalid_user.password = "dark psytrance"
        invalid_user.save()
        test_user_count(1)
      end
      it "fails to create user without password" do
        user = valid_user
        user.password = nil
        user.save()
        test_user_count(0)
      end
      it "fails to create user with invalid email" do
        user = valid_user
        user.email = "cebolinha"
        user.save()
        test_user_count(0)
      end
    end
  end
end
