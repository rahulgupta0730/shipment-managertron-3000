require "rails_helper"

RSpec.describe ShipmentsController, type: :controller do
  describe "GET #index" do
    let!(:company) { create(:company) }
    let!(:shipments) { create_list(:shipment, 30, company: company) }

    before do
      shipments.each do |shipment|
        create_list(:shipment_item, 2, shipment: shipment)
      end
    end

    it "returns http success" do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end

    it "returns paginated shipments" do
      get :index, format: :json
      json = JSON.parse(response.body)
      
      expect(json["shipments"].size).to eq(25) # default per_page
      expect(json["pagination"]["current_page"]).to eq(1)
      expect(json["pagination"]["total_count"]).to eq(30)
      expect(json["pagination"]["total_pages"]).to eq(2)
    end

    it "respects pagination parameters" do
      get :index, params: { page: 2, per_page: 10 }, format: :json
      json = JSON.parse(response.body)
      
      expect(json["shipments"].size).to eq(10)
      expect(json["pagination"]["current_page"]).to eq(2)
    end

    it "includes company and items in response" do
      get :index, format: :json
      json = JSON.parse(response.body)
      first_shipment = json["shipments"].first
      
      expect(first_shipment).to have_key("company_name")
      expect(first_shipment).to have_key("items")
      expect(first_shipment["items"]).to be_an(Array)
    end

    it "eager loads associations to avoid N+1 queries" do
      # With proper eager loading, we should have a fixed number of queries
      # regardless of the number of shipments
      queries = []
      ActiveSupport::Notifications.subscribe('sql.active_record') do |_, _, _, _, details|
        queries << details[:sql] unless details[:sql].include?('SCHEMA')
      end
      
      get :index, format: :json
      
      # Should be approximately 3 queries: 
      # 1. SELECT shipments
      # 2. SELECT companies
      # 3. SELECT shipment_items
      expect(queries.size).to be <= 5
    end
  end

  describe "GET #show" do
    let!(:company) { create(:company) }
    let!(:shipment) { create(:shipment, company: company) }
    let!(:items) { create_list(:shipment_item, 3, shipment: shipment) }

    it "returns http success" do
      get :show, params: { id: shipment.slug }, format: :json
      expect(response).to have_http_status(:success)
    end

    it "returns the correct shipment" do
      get :show, params: { id: shipment.slug }, format: :json
      json = JSON.parse(response.body)
      
      expect(json["shipment"]["slug"]).to eq(shipment.slug)
      expect(json["shipment"]["tracking_number"]).to eq(shipment.tracking_number)
    end

    it "includes all shipment items" do
      get :show, params: { id: shipment.slug }, format: :json
      json = JSON.parse(response.body)
      
      expect(json["shipment"]["items"].size).to eq(3)
    end

    it "returns 404 for non-existent slug" do
      get :show, params: { id: "nonexistent" }, format: :json
      expect(response).to have_http_status(:not_found)
      
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Resource not found")
    end
  end
end

