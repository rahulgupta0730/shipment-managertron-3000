json.shipments @shipments do |shipment|
  json.id                   shipment.id
  json.slug                 shipment.slug
  json.company_name         shipment.company.name
  json.origin_country       shipment.origin_country
  json.destination_country  shipment.destination_country
  json.tracking_number      shipment.tracking_number

  json.items shipment.shipment_items do |item|
    json.description        item.description
    json.weight             item.weight
  end
end

json.pagination do
  json.current_page   @shipments.current_page
  json.next_page      @shipments.next_page
  json.prev_page      @shipments.prev_page
  json.total_pages    @shipments.total_pages
  json.total_count    @shipments.total_count
end
