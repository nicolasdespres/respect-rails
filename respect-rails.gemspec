$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "respect/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "respect-rails"
  s.version     = Respect::Rails::VERSION
  s.authors     = ["Nicolas Despres"]
  s.email       = ["nicolas.despres@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Respect Rails."
  s.description = "TODO: Description of Respect Rails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc", "FAQ.txt"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'yard', '~> 0.8.5.2'
  s.add_development_dependency 'redcarpet', '~> 2.2.2'
end
