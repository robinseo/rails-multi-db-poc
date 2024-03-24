class ApplicationController < ActionController::API

  def use_readonly = ActiveRecord::Base.connected_to(role: :reading) { yield }

  def page_params = params.permit(:page, :per)
end
