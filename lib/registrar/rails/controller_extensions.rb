module Registrar
  module Rails
    module ControllerExtensions
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.before_action :try_to_store_current_profile_uid

        klass.class_eval do
          helper_method :current_profile
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

        def logout
          session[CURRENT_PROFILE_UID] = nil
        end

        def current_profile
          return @current_profile if @current_profile

          if uid = current_profile_uid_from_session
            @current_profile = Registrar::Middleware::config.handler.call(
              build_current_profile(uid)
            )
          end

          @current_profile
        end

        def current_profile?
          !!current_profile
        end

        def authentication_phase?
          params[:controller] == 'authentication' && params[:action] = 'callback'
        end

        private

        def store_current_profile_uid(registrar_profile)
          session[CURRENT_PROFILE_UID] = registrar_profile.uid
        end

        def current_profile_uid_from_session
          session[CURRENT_PROFILE_UID]
        end

        def build_current_profile(uid)
          {
            "provider" => {
              "name" => "session",
              "uid" =>  uid
            }
          }
        end
      end
    end
  end
end
