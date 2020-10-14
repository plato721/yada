require 'rails_helper'

describe Search do
  context "validations" do
    it "can't be created with the same criteria" do
      Search.create!(criteria: "molasses")

      duplicate = Search.new(criteria: "molasses")

      expect(duplicate.save).to be_falsey
      expect(duplicate).to_not be_valid
    end

    it "can't be created with differently cased duplicate criteria" do
      Search.create!(criteria: "a book")

      duplicate = Search.new(criteria: "A book")

      expect(duplicate.save).to be_falsey
      expect(duplicate).to_not be_valid
    end

    it "doesn't crash on empty criteria" do
      search = Search.new(criteria: nil)

      expect{ search.save }.to_not raise_error
      expect(search.criteria).to eq("")
    end
  end

  context "associations" do
    it "can have many users" do
      users = create_list(:user, 2)
      search = create(:search)

      search.users << users

      expect(search.users).to match_array(users)
    end
  end
end
