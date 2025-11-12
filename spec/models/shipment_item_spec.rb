require "rails_helper"

RSpec.describe ShipmentItem, type: :model do
  describe "associations" do
    it { should belong_to(:shipment).required }
  end

  describe "validations" do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:weight) }
    it { should validate_numericality_of(:weight).is_greater_than(0) }
  end
end

