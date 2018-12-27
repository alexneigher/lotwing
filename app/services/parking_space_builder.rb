class ParkingSpaceBuilder

  def initialize(params, dealership_id)
    @geo_info = JSON.parse(params[:shape][:geo_info])
    @horizontal_splits = params[:shape][:horizontal_splits].to_i
    @dealership_id = dealership_id
  end

  def perform
    #sometimes multiple are passed in
    @geo_info.each do |shape|
      save_shape(shape)
    end
  end

  def save_shape(shape)    
    first_point = shape['geometry']['coordinates'].first.first
    second_point = shape['geometry']['coordinates'].first.second
    third_point = shape['geometry']['coordinates'].first.third
    fourth_point = shape['geometry']['coordinates'].first.fourth
    
    a = Geokit::LatLng.new(first_point[1], first_point[0])
    b = Geokit::LatLng.new(second_point[1], second_point[0])
    c = Geokit::LatLng.new(third_point[1], third_point[0])
    d = Geokit::LatLng.new(fourth_point[1], fourth_point[0])
    
    corners = [a, b, c, d]

    if @horizontal_splits == 0
      corners = [a, b, c, d]
    elsif @horizontal_splits == 1

      corners = [a, corners[0].midpoint_to(corners[1]), b, c, corners[2].midpoint_to(corners[3]), d]
    
    elsif @horizontal_splits == 3
      ab = a.midpoint_to(b)
      see_dee = c.midpoint_to(d)
      aab = a.midpoint_to(ab)
      abb = ab.midpoint_to(b)
      ccd = c.midpoint_to(see_dee)
      cdd = see_dee.midpoint_to(d)
      corners = [ a, aab, ab, abb, b, c, ccd, see_dee, cdd, d ]

    elsif @horizontal_splits == 7
      ab = a.midpoint_to(b)
      see_dee = c.midpoint_to(d)
      aab = a.midpoint_to(ab)
      abb = ab.midpoint_to(b)
      aaab = a.midpoint_to(aab)
      aaabb = aab.midpoint_to(ab)
      aabbb = ab.midpoint_to(abb)
      abbb = b.midpoint_to(abb)
      ccd = c.midpoint_to(see_dee)
      cccd = c.midpoint_to(ccd)
      cccdd = ccd.midpoint_to(see_dee)
      cdd = see_dee.midpoint_to(d)
      ccddd = see_dee.midpoint_to(cdd)
      cddd = d.midpoint_to(cdd)

      corners = [ a, aaab, aab, aaabb, ab, aabbb, abb, abbb, b, c, cccd, ccd, cccdd, see_dee, ccddd, cdd, cddd, d ]
    end

    new_shapes = []

    (@horizontal_splits + 1).times do |i|
      new_shapes << [
                    corners[i],
                    corners[i + 1],
                    corners[corners.length - (i + 2)],
                    corners[corners.length - (i + 1)],
                    corners[i],
                  ]
      
    end  

    new_shapes.each do |shape|
      geo = {"id"=> SecureRandom.hex(15),
        "type"=>"Feature",
        "properties"=>{},
        "geometry"=>
         {"coordinates"=>
           [[[shape[0].lng, shape[0].lat],
             [shape[1].lng, shape[1].lat],
             [shape[2].lng, shape[2].lat],
             [shape[3].lng, shape[3].lat],
             [shape[0].lng, shape[0].lat]]],
          "type"=>"Polygon"}
       }

       Shape.create!( 
         dealership_id: @dealership_id,
         geo_info: geo, 
         shape_type: 0
       )

    end
    
  end
end