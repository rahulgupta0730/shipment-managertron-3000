FactoryBot.define do
  factory :shipment do
    association :company
    destination_country { Faker::Address.country_code }
    origin_country { Faker::Address.country_code }
    tracking_number { "#{Faker::Address.country_code}#{Faker::Number.number(digits: 9)}#{Faker::Address.country_code}" }
    slug { SecureRandom.urlsafe_base64(8) }
  end
end
