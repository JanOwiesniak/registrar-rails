require 'yaml'

module Registrar
  module Rails
    module ControllerExtensions
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.before_action :try_to_store_current_profile

        klass.class_eval do
          helper_method :current_profile
          helper_method :reload_current_profile
          helper_method :current_profile?
          helper_method :logout
        end
      end

      module InstanceMethods
        REGISTRAR_PROFILE_KEY = 'registrar.profile'
        CURRENT_PROFILE_KEY = 'current.profile'

        def try_to_store_current_profile
          if registrar_profile = env[REGISTRAR_PROFILE_KEY]
            store_current_profile(registrar_profile)
          end
        end

        def store_current_profile(registrar_profile)
          session[CURRENT_PROFILE_KEY] = YAML.dump(registrar_profile)
        end

        def logout
          session[CURRENT_PROFILE_KEY] = nil
        end

        def reload_current_profile
          if current_profile
            env[REGISTRAR_PROFILE_KEY] = Registrar::Middleware::config.handler.call(current_profile)
            try_to_store_current_profile
          end
        end

        def current_profile
          if session[CURRENT_PROFILE_KEY]
            YAML.load session[CURRENT_PROFILE_KEY]
          else
            nil
          end
        end

        def current_profile?
          !!current_profile
        end

        def authentication_phase?
          params[:controller] == 'authentication' && params[:action] = 'callback'
        end
      end
    end
  end
end
