class ParkingSpaceBuilder

  def initialize(params, dealership_id)
    @geo_info = JSON.parse(params[:shape][:geo_info])
    @dealership_id = dealership_id
  end

  def perform
    #find the mid point on one side
    shape = @geo_info.first
    
    first_point = shape['geometry']['coordinates'].first.first
    second_point = shape['geometry']['coordinates'].first.second
    third_point = shape['geometry']['coordinates'].first.third
    fourth_point = shape['geometry']['coordinates'].first.fourth
    
    a = Geokit::LatLng.new(first_point[1], first_point[0])
    b = Geokit::LatLng.new(second_point[1], second_point[0])
    c = Geokit::LatLng.new(third_point[1], third_point[0])
    d = Geokit::LatLng.new(fourth_point[1], fourth_point[0])
    
    ab_midpoint = a.midpoint_to(b)
    cd_midpoint = c.midpoint_to(d)

    ad_midpoint = a.midpoint_to(d)
    bc_midpoint = b.midpoint_to(c)

    ab_cd_midpoint = ab_midpoint.midpoint_to(cd_midpoint)

    new_geo_info_1 = {"id"=> SecureRandom.hex(15),
                       "type"=>"Feature",
                       "properties"=>{},
                       "geometry"=>
                        {"coordinates"=>
                          [[[a.lng, a.lat],
                            [ab_midpoint.lng, ab_midpoint.lat],
                            [ab_cd_midpoint.lng, ab_cd_midpoint.lat],
                            [ad_midpoint.lng, ad_midpoint.lat],
                            [a.lng, a.lat]]],
                         "type"=>"Polygon"}
                      }

    new_geo_info_2 = {"id"=> SecureRandom.hex(15),
                       "type"=>"Feature",
                       "properties"=>{},
                       "geometry"=>
                        {"coordinates"=>
                          [[[ab_midpoint.lng, ab_midpoint.lat],
                            [b.lng, b.lat],
                            [bc_midpoint.lng, bc_midpoint.lat],
                            [ab_cd_midpoint.lng, ab_cd_midpoint.lat],
                            [ab_midpoint.lng, ab_midpoint.lat]]],
                         "type"=>"Polygon"}
                      }

    new_geo_info_3 = {"id"=> SecureRandom.hex(15),
                       "type"=>"Feature",
                       "properties"=>{},
                       "geometry"=>
                        {"coordinates"=>
                          [[[bc_midpoint.lng, bc_midpoint.lat],
                            [c.lng, c.lat],
                            [cd_midpoint.lng, cd_midpoint.lat],
                            [ab_cd_midpoint.lng, ab_cd_midpoint.lat],
                            [bc_midpoint.lng, bc_midpoint.lat]]],
                         "type"=>"Polygon"}
                      }

    new_geo_info_4 = {"id"=> SecureRandom.hex(15),
                       "type"=>"Feature",
                       "properties"=>{},
                       "geometry"=>
                        {"coordinates"=>
                          [[[cd_midpoint.lng, cd_midpoint.lat],
                            [d.lng, d.lat],
                            [ad_midpoint.lng, ad_midpoint.lat],
                            [ab_cd_midpoint.lng, ab_cd_midpoint.lat],
                            [cd_midpoint.lng, cd_midpoint.lat]]],
                         "type"=>"Polygon"}
                      }


    [new_geo_info_1, new_geo_info_2, new_geo_info_3, new_geo_info_4].each do |geo|

      Shape.create!( 
        dealership_id: @dealership_id,
        geo_info: geo, 
        shape_type: 0
      )
    end
  end
end