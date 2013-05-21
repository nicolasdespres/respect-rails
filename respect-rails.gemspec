$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "respect/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "respect-rails"
  s.version     = Respect::Rails::VERSION
  s.authors     = ["Nicolas Despres"]
  s.email       = ["nicolas.despres@gmail.com"]
  s.homepage    = "http://nicolasdespres.github.io/respect-rails"
  s.summary     = "REST API specification/documentation tool for Rails."
  s.description = "Respect for Rails lets you write the documentation of your REST API using Ruby code. Documentation is published using a Rails engine to stay synchronized. Filter is available to validate requests and responses. Parameters are sanitized so you get URI object instead of string object containing an URI for example."

  s.files = Dir["{app,config,db,lib}/**/*"] + [
    "MIT-LICENSE",
    "Rakefile",
    "README.md",
    "FAQ.md",
    "RELEASE_NOTES.md",
    "RELATED_WORK.md",
  ]
  s.test_files = Dir["test/**/*"] - Dir["test/dummy/tmp/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "respect", "~> 0.1.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'yard', '~> 0.8.5.2'
  s.add_development_dependency 'redcarpet', '~> 2.2.2'
  s.add_development_dependency 'mocha', '~> 0.14.0'
end
