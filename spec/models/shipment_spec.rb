require "rails_helper"

RSpec.describe Shipment, type: :model do
  describe "associations" do
    it { should belong_to(:company) }
    it { should have_many(:shipment_items).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:shipment) }

    it { should validate_presence_of(:origin_country) }
    it { should validate_presence_of(:destination_country) }
    it { should validate_presence_of(:tracking_number) }
    it { should validate_uniqueness_of(:tracking_number) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe "callbacks" do
    describe "#generate_slug" do
      it "generates a slug before validation on create" do
        shipment = build(:shipment, slug: nil)
        expect(shipment.slug).to be_nil
        shipment.valid?
        expect(shipment.slug).to be_present
      end

      it "does not override an existing slug" do
        shipment = build(:shipment, slug: "custom-slug")
        shipment.valid?
        expect(shipment.slug).to eq("custom-slug")
      end

      it "generates unique slugs even on collision" do
        existing = create(:shipment, slug: "test123")
        
        allow(SecureRandom).to receive(:urlsafe_base64)
          .and_return("test123", "unique456")
        
        new_shipment = build(:shipment, slug: nil)
        new_shipment.valid?
        expect(new_shipment.slug).to eq("unique456")
      end
    end
  end

  describe "cascade deletion" do
    it "destroys associated shipment_items when shipment is destroyed" do
      shipment = create(:shipment)
      create_list(:shipment_item, 3, shipment: shipment)
      
      expect { shipment.destroy }.to change { ShipmentItem.count }.by(-3)
    end
  end
end
