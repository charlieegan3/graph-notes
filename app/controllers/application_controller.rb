class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV.fetch('USERNAME'), password: ENV.fetch('PASSWORD')
end
