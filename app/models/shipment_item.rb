class ShipmentItem < ApplicationRecord
  belongs_to :shipment, optional: false

  validates :description, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }
end
