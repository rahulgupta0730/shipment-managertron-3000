class ShipmentItem < ApplicationRecord
  belongs_to :shipment

  validates :description, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }
end
