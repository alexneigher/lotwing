class BarcodesController < ApplicationController


  def create
    @vin = params[:vin]
    @stock_number = params[:stock_number]

    @vehicle = Vehicle.find_by_stock_number(@stock_number)

    respond_to do |format|
     format.pdf do
       render pdf: "Vehicle Barcode",
       template: "barcodes/create.html.haml",
       orientation: "Landscape",
       layout: 'pdf.html.erb'
     end
    end
  end

end