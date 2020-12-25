class BarcodesController < ApplicationController


  def create
    @vin = params[:vin]
    @stock_number = params[:stock_number]

    @vehicle = Vehicle.find_by_stock_number(@stock_number)

    qrcode = RQRCode::QRCode.new(@vehicle.vin)

    # NOTE: showing with default options specified explicitly
    @png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 0,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
    )

    respond_to do |format|
     format.pdf do
       render pdf: "Vehicle QR Code",
       template: "barcodes/create.html.haml",
       layout: 'pdf.html.erb'
     end
    end
  end

end