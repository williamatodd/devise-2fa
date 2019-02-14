class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def show
    render html: "", layout: "application"
  end
end
