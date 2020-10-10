require 'rails_helper'

describe User do
  context "validations" do
    context "email" do
      it "must have a unique email address" do
        good_user = User.create!(email: "abe.lincoln@hotmail.com")

        bad_user = User.new(email: "abe.lincoln@hotmail.com")

        expect(bad_user.save).to be_falsey
        expect(bad_user).to_not be_valid
      end

      it "has a unique email address independent of character case" do
        good_user = User.create!(email: "aBe.lincoln@hotmail.com")

        bad_user = User.new(email: "abe.lincOln@hotmail.com")

        expect(bad_user.save).to be_falsey
        expect(bad_user).to_not be_valid

        good_user.reload
        expect(good_user.email).to eql("abe.lincoln@hotmail.com")
      end

      it "must have an email address" do
        user = User.new
        expect(user).to_not be_valid
      end
    end

    context "token" do
      it "is assigned a token" do
        user = User.new(email: "something@test.com")

        expect(user).to be_valid
        expect(user.token).to be_present
      end

      it "requires a unique token" do
        user = User.create!(email: "something@test.com", token: "a8b")
        duplicate_user = User.create(email: "something_else@test.com", token: "a8b")

        expect(duplicate_user).to_not be_valid
      end
    end
  end
end
