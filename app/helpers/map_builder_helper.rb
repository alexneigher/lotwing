module MapBuilderHelper

  def map_builder_icon_shape(shape)
    case shape.shape_type
      when "parking_space"
        'fa-car'
      when "building"
        'fa-building'
      when "parking_lot"
        'fa-square'
      end

  end
end