class SomeController < ApplicationController
  def index
    render :json => current_profile
  end
end
