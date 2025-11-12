json.shipment do
  json.id                   @shipment.id
  json.slug                 @shipment.slug
  json.company_name         @shipment.company.name
  json.origin_country       @shipment.origin_country
  json.destination_country  @shipment.destination_country
  json.tracking_number      @shipment.tracking_number
  json.created_at           @shipment.created_at
  json.updated_at           @shipment.updated_at

  json.items @shipment.shipment_items do |item|
    json.id                 item.id
    json.description        item.description
    json.weight             item.weight
  end
end

