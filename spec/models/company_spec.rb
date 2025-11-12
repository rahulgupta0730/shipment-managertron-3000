require "rails_helper"

RSpec.describe Company, type: :model do
  describe "associations" do
    it { should have_many(:shipments).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "cascade deletion" do
    it "destroys associated shipments when company is destroyed" do
      company = create(:company)
      create_list(:shipment, 3, company: company)
      
      expect { company.destroy }.to change { Shipment.count }.by(-3)
    end
  end
end

