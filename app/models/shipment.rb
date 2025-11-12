class Shipment < ApplicationRecord
  belongs_to :company, optional: false
  has_many :shipment_items, dependent: :destroy

  validates :origin_country, presence: true
  validates :destination_country, presence: true
  validates :tracking_number, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    return if slug.present?
    
    loop do
      self.slug = SecureRandom.urlsafe_base64(8)
      break unless Shipment.exists?(slug: slug)
    end
  end
end
