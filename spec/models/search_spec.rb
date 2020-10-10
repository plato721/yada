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
  end
end