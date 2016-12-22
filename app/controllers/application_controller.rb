class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :verify

  def verify
    cookies.permanent.signed[:password] = params[:password] if params[:password]

    if cookies.permanent.signed[:password] != ENV['PASSWORD']
      return render plain: 'Enter Password', status: 401
    end
  end
end
