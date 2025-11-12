FactoryBot.define do
  factory :shipment_item do
    association :shipment
    description { %w(iPhone iPad Watch iMac MacBook Mouse Keyboard).sample }
    weight { (1..5).to_a.sample }
  end
end
