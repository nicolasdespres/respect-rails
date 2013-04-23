# Controller to get all the information relative to the
# REST API of this application.
class RespectController < ApplicationController
  def index
    @routes = Respect::Rails::Info.new
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
