require "registrar"
require "registrar/rails/engine"
require "registrar/rails/controller_extensions"

module Registrar
  module Rails
    def self.configure(&configuration)
      Registrar::Rails::Engine.configure(&configuration)
    end
  end
end
