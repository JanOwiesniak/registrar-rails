require 'registrar'

ActiveSupport.on_load(:action_controller) do
  include Registrar::Rails::ControllerExtensions
end
