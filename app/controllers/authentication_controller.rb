class AuthenticationController < ApplicationController
  def sign_in
  end

  def sign_up
  end

  def authenticate
    render :text => "<pre>#{presentable_authentication.to_yaml}</pre>"
  end
end
