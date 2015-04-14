module Registrar
  class Profile < Delegator
    def initialize(obj)
      super
      @delegate_sd_obj = obj
    end

    def __getobj__
      @delegate_sd_obj
    end

    def __setobj__(obj)
      @delegate_sd_obj = obj
    end
  end

  module Rails
    module ControllerExtensions
      def self.included(klass)
        klass.send :include, InstanceMethods
        klass.before_action :try_to_store_registrar_profile

        klass.class_eval do
          helper_method :current_profile
          helper_method :current_profile?
          helper_method :logged_in?

          helper_method :registrar_profile
          helper_method :registrar_profile?

          helper_method :authentication_phase?

          helper_method :logout
          helper_method :presentable_authentication
        end
      end

      module InstanceMethods
        REGISTRAR_PROFILE_KEY = 'registrar.profile'

        def try_to_store_registrar_profile
          if registrar_profile = request.env['registrar.profile']
            store_registrar_profile(registrar_profile)
          end
        end

        def store_registrar_profile(registrar_profile)
          session[REGISTRAR_PROFILE_KEY] = registrar_profile
        end

        def current_profile
          return @current_profile if @current_profile
          try_to_set_current_profile
        end

        def logout
          @current_profile = nil
        end

        def current_profile?
          !!current_profile
        end
        alias_method :logged_in?, :current_profile?

        def try_to_set_current_profile
          if registrar_profile?
            @current_user = build_profile(registrar_profile)
          end
        end

        def registrar_profile?
          !!registrar_profile
        end

        def registrar_profile
          session[REGISTRAR_PROFILE_KEY]
        end

        def build_profile(profile)
          ::Registrar::Profile.new(profile)
        end

        def authentication_phase?
          params[:controller] == 'authentication' && params[:action] = 'callback'
        end

        def presentable_authentication
          {
            'env.omniauth.auth' => request.env['omniauth.auth'],
            'env.registrar.auth' => request.env['registrar.auth'],
            'env.registrar.profile' => request.env['registrar.profile'],
            'session.registrar_profile' => registrar_profile,
            'runtime.current_profile' => current_profile
          }
        end
      end
    end
  end
end
