class RegistrarController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sign_out
    sign_out_current_profile
    redirect_to after_sign_out_url
  end

  def callback
    redirect_to after_auth_url
  end
end
