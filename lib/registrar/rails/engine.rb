require "registrar"

module Registrar
  module Rails
    class Engine < ::Rails::Engine
      initializer "registrar.rails",
                  :after => :load_config_initializers,
                  :before => :build_middleware_stack do |app|
        @@configuration.call
      end

      def self.configure(&configuration)
        @@configuration = lambda do
          Registrar::Middleware.configure(&configuration)
        end
      end
    end
  end
end
