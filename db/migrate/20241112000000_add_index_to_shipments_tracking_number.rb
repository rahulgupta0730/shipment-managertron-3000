class AddIndexToShipmentsTrackingNumber < ActiveRecord::Migration[6.1]
  def change
    add_index :shipments, :tracking_number, unique: true
  end
end

