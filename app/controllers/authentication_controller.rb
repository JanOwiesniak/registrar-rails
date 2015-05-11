class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sign_in
  end

  def sign_up
  end

  def authenticate
    redirect_to '/'
  end
end
