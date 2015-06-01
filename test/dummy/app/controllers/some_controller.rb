class SomeController < ApplicationController
  def index
    render :text => current_profile.uid
  end
end
