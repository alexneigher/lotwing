class TagSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :event_type
  belongs_to :shape
  
end
