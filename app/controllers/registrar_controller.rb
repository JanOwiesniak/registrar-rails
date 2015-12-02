class RegistrarController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    redirect_to after_auth_url
  end
end
