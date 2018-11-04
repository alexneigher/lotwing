class DataFeedSyncService
  #this opens an FTP connection, maybe extract out the FTP part fo a parent (caller) service?
  require 'net/ftp'

  def initialize(dealership_id)
    @dealership_id = dealership_id
    @vehicle_data = ''
  end

  def perform!
    check_for_data_sync_setup

    download_file

    update_vehicles
  end

  private

    def check_for_data_sync_setup
      raise "Dealership not setup for data sync" unless dealership.data_sync&.provider_id.present?
    end

    def file_name
      "#{dealership.data_sync.provider_id}_#{Date.current.strftime('%Y-%m-%d')}.txt"
    end

    def dealership
      @dealership ||= Dealership.find_by_id(@dealership_id)
    end

    def download_file
      Net::FTP.open('ftp.upperpark.com', 'alexn2018', 'r7e@89uWb9q') do |ftp|    
        ftp.chdir('/vauto_data')
        puts ftp.list('*')
        puts ftp.nlst()

        datafile = 'sunnyvalevolkswagenvw_2018-08-21.txt'
        ftp.getbinaryfile(datafile, datafile, 1024) do |c|
          @vehicle_data << c
        end
      end      
    end

    #this part should be its own class separate from the FTP connection parts
    def update_vehicles
      #split file on new line, and do looping magic
      rows = @vehicle_data.split("\n")
      
      # #start at 1 because headers are first
      (1..rows.length - 1).each do |i|

        # each row = 1 vehicle
        row = rows[i]
        data = row.split("|")

        next if dealership.vehicles.find_by_vin(data[1])

        dealership
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
    end

end