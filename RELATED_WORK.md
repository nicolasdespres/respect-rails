# Related works

This section describes some projects sharing more or less the same purpose as
_Respect for Rails_. The goal is to have an overview of the eco-system around this
topic to borrow ideas and to drive implementation.

This section is not meant to be accurate event if we try to stay objective here.

## [apipie-rails](https://github.com/Pajk/apipie-rails)

* Documentation generation using an engine.
* Ruby DSL to describe documentation.
* Support validators.
* Resource and controllers description API.
* Good looking generated doc.
* Allow to statically deployed the documentation apart of the Rails app.
* TODO: Is there sanitizers?
* TODO: Is there headers checker?
* TODO: Is there url and query parameters ?
* TODO: Support for json-schema.org standard ?

TODO: Study to be continued...

## [Doctorj](https://github.com/coopernurse/doctorj)

* No Ruby DSL but uses a Markdown file as input.
  * Syntax to describe schema in Markdown looks compact and close to what we have
    in our Ruby DSL.
* Generate API documentation in HTML.
* Not integrated in Rails.
  * Not bind to the routes.
  * No HTTP headers validation possible.
* No sanitizer.

## [Rails::API](https://github.com/rails-api/rails-api)

* Lighter Rails for JSON only application.

## [Active Model Serializer](https://github.com/rails-api/active_model_serializers)

* Object oriented way to organize JSON view code.

## [StrongParameters](https://github.com/rails/strong_parameters)

* No documentation generation.
* No sanitizer.
* No response validation.
