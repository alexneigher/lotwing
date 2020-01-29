Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_options = lambda do |event|
    # omit secret/unimportant/redundant parameters
    exceptions = %w(controller action format commit authenticity_token utf8)
    { params: event.payload[:params].except(*exceptions), user_id: event.payload[:user_id] }
  end
end