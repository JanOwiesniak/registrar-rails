require "registrar"

module Registrar
  module Rails
    class Engine < ::Rails::Engine
      @@configuration = nil

      initializer "registrar.rails",
                  :after => :load_config_initializers,
                  :before => :build_middleware_stack do |app|
        if @@configuration
          @@configuration.call
        end
      end

      def self.configure(&configuration)
        block = lambda do |config|
          configuration.call config
          config.middleware(::Rails.application.config.middleware)
        end

        @@configuration = lambda do
          Registrar::Middleware.configure(&block)
        end
      end
    end
  end
end
