class StubbedRegistarMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env['registrar.profile'] = ApplicationSpecificProfile.new
    @app.call(env)
  end

  private

  class ApplicationSpecificProfile
    def uid
      '1'
    end
  end
end

Rails.application.config.middleware.insert_after(ActionDispatch::Session::CookieStore, StubbedRegistarMiddleware)

Registrar::Rails.configure do |config|
  config.handler(Proc.new{|profile| profile})
end
