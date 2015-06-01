module Registrar
  module Rails
    class CurrentProfile
      attr_reader :uid
      def initialize(uid)
        @uid = uid
      end

      def profile_uid
        @uid
      end
    end

    module ControllerExtensions
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.before_action :try_to_store_current_profile_uid

        klass.class_eval do
          helper_method :current_profile
          helper_method :reload_current_profile
          helper_method :current_profile?
          helper_method :logout
        end
      end

      module InstanceMethods
        REGISTRAR_PROFILE_KEY = 'registrar.profile'
        CURRENT_PROFILE_UID = 'current.profile.uid'

        def try_to_store_current_profile_uid
          if registrar_profile = env[REGISTRAR_PROFILE_KEY]
            store_current_profile_uid(registrar_profile)
          end
        end

        def store_current_profile_uid(registrar_profile)
          session[CURRENT_PROFILE_UID] = registrar_profile.uid
        end

        def current_profile_uid
          session[CURRENT_PROFILE_UID]
        end

        def logout
          session[CURRENT_PROFILE_UID] = nil
        end

        def reload_current_profile
        end

        def current_profile
          return @current_user if @current_user

          if current_profile_uid
            @current_user = Registrar::Middleware::config.handler.call(
              Registrar::Rails::CurrentProfile.new(current_profile_uid)
            )
          end

          @current_user
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
