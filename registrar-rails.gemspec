$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "registrar/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "registrar-rails"
  s.version     = Registrar::Rails::VERSION
  s.authors     = ["Jan Owiesniak"]
  s.email       = ["jan@featurefabrik.de"]
  s.summary     = "Rails Engine to integrate Registrar"
  s.license     = ""

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "registrar"
end
