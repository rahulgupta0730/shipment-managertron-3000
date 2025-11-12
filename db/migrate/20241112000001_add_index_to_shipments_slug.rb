class AddIndexToShipmentsSlug < ActiveRecord::Migration[6.1]
  def change
    add_index :shipments, :slug, unique: true
  end
end

