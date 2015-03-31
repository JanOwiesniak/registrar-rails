# Registrar::Rails

Registar::Rails is a [Rails Engine](http://guides.rubyonrails.org/engines.html) to simply the integration of [Registar](https://github.com/JanOwiesniak/registrar) into [Rails](https://github.com/rails/rails).

## Installation

Add this line to your application's Gemfile:

    gem 'registrar-rails'

And then execute:

    $ bundle

## Getting Started


Add the OmniAuth strategy you want to use to your `Gemfile`

```ruby
gem 'omniauth-facebook-access-token'
```

Add a file under `config/initializers/` and give it a meaningful name (e.g.
authentication.rb)

```ruby
Registrar::Rails.configure do |config|
  # Define which OmniAuth strategies you want to use
  config.strategies 'facebook_access_token'

  # The #call method will be invoked with env['registrar.auth']
  # The return value is stored in env['registrar.profile']
  config.handler(ProfileHandler.new(ActiveRecord::User))
end

# config.handler expects a object that responds to #call
# The #call method could for example find or create a new user based on the authentication result

class ProfileHandler
  def initialize(gateway)
    @gateway = gateway
  end

  def call(schema)
    provider = schema[:provider][:name]
    external_uid = schema[:provider][:uid]

    @gateway.find_or_create_by_provider_and_external_uid(provider, external_uid)
  end
end
```

## Controller Extensions

There are following helper methods avaliable in your controller

* `current_profile` - env['registrar.profile'] stored in the session
* `logged_in?` - true if current_profile exists
* `logout` - deletes current_profile from session
