class Company < ApplicationRecord
  has_many :shipments, dependent: :destroy

  validates :name, presence: true
end
