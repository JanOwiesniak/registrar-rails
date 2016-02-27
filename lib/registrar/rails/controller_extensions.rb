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
          @current_profile ||= fetch_profile_from_session
        end

        def current_profile?
          !!current_profile
        end

        def sign_out_current_profile
          session[CURRENT_PROFILE_UID] = nil
          @current_profile = nil
        end

        private

        def fetch_profile_from_session
          if uid = session[CURRENT_PROFILE_UID]
            Registrar::Middleware::config.handler.call(cached_profile(uid))
          end
        end

        def cached_profile(uid)
          {
            "provider" => {
              "name" => "session",
              "uid" => uid
            }
          }
        end
      end
    end
  end
end
