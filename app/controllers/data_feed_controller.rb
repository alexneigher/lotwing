class DataFeedController < ApplicationController
  require 'csv'

  def new
  end

  def create

    myfile = params[:data_feed][:file]

    xml_contents = File.read(myfile.path)

    rows = xml_contents.split("\r\n")

    puts rows[0].split("|")

    #start at 1 because headers are first
    (1..rows.length - 1).each do |i|
      # each row = 1 vehicle
      row = rows[i]
      data = row.split("|")

      next if current_user.dealership.vehicles.find_by_vin(data[1])

      current_user
        .dealership
        .vehicles
        .create(
          vin: data[1],
          stock_number: data[2],
          year: data[3],
          make: data[4],
          model: data[5],
          trim_level: data[6],
          doors: data[7],
          body_style: data[8],
          transmission: data[9],
          mileage: data[10],
          engine: data[15],
          engine_size: data[16],
          model_code: data[17],
          certified: data[18],
          retail_value: data[19],
          invoice_price: data[20],
          asking_price: data[21],
          wholesale_price: data[22],
          msrp: data[23],
          sale_price: data[24],
          vehicle_type: data[25],
          options: data[26],
          options_codes: data[27],
          comments: data[28],
          photo_url_list: data[29],
          package_code: data[30],
          fuel: data[31],
          drive_line: data[32],
          rear_wheel: data[33],
          status: data[34],
          raw_data_feed_output: data.join("|")
        )
      puts data    
    end
    

    redirect_to vehicles_path
  end
end

# ordered keys
# 0 Provider ID
# 1 VIN
# 2 Stock Number
# 3 Year
# 4 Make
# 5 Model
# 6 Trim Level
# 7 Doors
# 8 Body Style
# 9 Transmission
# 10 Mileage
# 11 Exterior Color
# 12 Exterior Color Code
# 13 Interior Color
# 14 Interior Color Code
# 15 Engine
# 16 Engine Size
# 17 Model Code
# 18 Certified
# 19 Retail Value
# 20 Invoice Price
# 21 Asking Price
# 22 Wholesale Price
# 23 MSRP
# 24 Sale Price
# 25 Type
# 26 Options
# 27 Options Codes
# 28 Comments
# 29 Photo Url List
# 30 Package Code
# 31 Fuel
# 32 Driveline
# 33 R/W
# 34 Status
# 35 Cost
# 36 Video Url
# 37 Age
# 38 Misc
# 39 Dealer Discounted
# 40 Total Rebates
# 41 Guaranteed Rebates
# 42 Optional Rebates
# 43 Photos Last Modified Date