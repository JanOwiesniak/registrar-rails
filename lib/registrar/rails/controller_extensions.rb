module Registrar
  module Rails
    module ControllerExtensions
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.before_action :try_to_store_current_profile_uid

        klass.class_eval do
          helper_method :current_profile
          helper_method :current_profile?
          helper_method :sign_out_current_profile
        end
      end

      module InstanceMethods
        REGISTRAR_PROFILE_KEY = 'registrar.profile'
        CURRENT_PROFILE_UID = 'current.profile.uid'

        def try_to_store_current_profile_uid
          if registrar_profile = env[REGISTRAR_PROFILE_KEY]
            session[CURRENT_PROFILE_UID] = registrar_profile.uid
          end
        end

        def current_profile
          if session[CURRENT_PROFILE_UID]
            @current_profile = fetch_profile_in_session
          end
        end

        def current_profile?
          !!current_profile
        end

        def sign_out_current_profile
          session[CURRENT_PROFILE_UID] = nil
        end

        private

        def fetch_profile_in_session
          Registrar::Middleware::config.handler.call(
            {
              "provider" => {
                "name" => "session",
                "uid" => session[CURRENT_PROFILE_UID]
              }
            }
          )
        end
      end
    end
  end
end
