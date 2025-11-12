class ShipmentsController < ApplicationController
  def index
    @shipments = Shipment.includes(:company, :shipment_items)
                         .page(params[:page])
                         .per(params[:per_page] || 25)
  end

  def show
    @shipment = Shipment.includes(:company, :shipment_items)
                        .find_by!(slug: params[:id])
  end
end
