class DataFeedSyncService
  #this opens an FTP connection, maybe extract out the FTP part fo a parent (caller) service?
  require 'net/ftp'

  def initialize(dealership_id)
    @dealership_id = dealership_id
    @vehicle_data = ''
  end

  def perform!
    return unless dealership.data_sync&.provider_id.present?

    download_file

    update_vehicles
  end

  private

    def file_name
      "#{dealership.data_sync.provider_id}_#{Date.current.strftime('%Y-%m-%d')}.txt"
    end

    def dealership
      @dealership ||= Dealership.find_by_id(@dealership_id)
    end

    def download_file
      Net::FTP.open('ftp.upperpark.com', 'alexn2020@upperpark.com', 'r7e@89uWb9q') do |ftp|
        ftp.chdir('/')
        datafile = ftp.nlst().last

        ftp.getbinaryfile(datafile, datafile, 1024) do |c|
          @vehicle_data << c
        end
      end
    end

    #this part should be its own class separate from the FTP connection parts
    def update_vehicles
      stock_numbers = []
      #split file on new line, and do looping magic
      rows = @vehicle_data.split("\n")

      # #start at 1 because headers are first
      (1..rows.length - 1).each do |i|
        # each row = 1 vehicle
        row = rows[i]
        data = row.split("|")
        stock_numbers << data[1] #so we know which vehicles to delete later

        vehicle = dealership.vehicles.with_deleted.find_or_create_by(stock_number: data[1].upcase)
        vehicle
          .update(
            vin: data[0],
            year: data[2],
            make: data[3],
            model: data[4],
            trim_level: data[5],
            body_style: data[6],
            transmission: data[7],
            mileage: mileage_calculation(vehicle, data),
            engine: data[9],
            engine_size: data[10],
            model_code: data[11],
            certified: data[12],
            retail_value: data[13],
            invoice_price: data[14],
            asking_price: data[15],
            wholesale_price: data[16],
            msrp: data[17],
            sale_price: data[18],
            vehicle_type: data[19],
            options: data[20],
            options_codes: data[21],
            comments: data[22],
            photo_url_list: data[23],
            package_code: data[24],
            fuel: data[25],
            drive_line: data[26],
            status: data[28],
            usage_type: data[29].chomp == 'U' ? "is_used" : "is_new",
            age_in_days: data[30].presence || 0,
            color: data[31].chomp,
            creation_source: "data_feed_created",
            raw_data_feed_output: data.join("|")
          )
      end

      dealership.vehicles.with_deleted.data_feed_deleteable.where.not(stock_number: stock_numbers).destroy_all #delete all data feed inventory that does not show up
      dealership.data_sync.update(last_run_at: DateTime.now)
    end


    def mileage_calculation(vehicle, data)
      return vehicle.mileage if vehicle.mileage.present? && vehicle.mileage > 0

      return data[8].presence || 0
    end
end