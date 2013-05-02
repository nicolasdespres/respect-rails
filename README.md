# Respect plugin for Rails

[Respect](https://github.com/nicolasdespres/respect) integration for Rails 3.x.

# Features

* Based on [Respect](https://github.com/nicolasdespres/respect) to compactly specify your REST API.
* Controllers' helpers to automatically validates and sanitize incoming parameters.
* A Rails engine to mount in your application to publish your public REST API documentation.
  * Your documentation will always be up to date with your application.
  * Access the full API documentation.
  * Deployed transparently with your application so you don't have to worry about it.
* A DSL to group your requests and responses schema by controllers.

# Take a tour

_Respect for Rails_ let's you easily describe the structure of incoming requests and outgoing responses
using a simple and compact Ruby DSL. Assuming you have the scaffold of a `ContactsController`, the structure
for its `create` action may look like this:

```ruby
# in app/schemas/contacts_controller_schema.rb
class ContactsControllerSchema < ApplicationControllerSchema
  def create
    request do
      body_params do |s|
        s.object "contact" do |s|
          s.string "name"
          s.integer "age"
          s.uri "homepage"
        end
      end
    end
    response_for do |status|
      status.ok # contacts/create.schema
      status.unprocessable_entity do
        body_with_object do |s|
          s.string "error"
        end
      end
    end
  end
end
```

Long response schema may be defined in another file instead of inlined in the controller code:

```ruby
# in app/schemas/contacts/create.schema
body_with_object do |s|
  s.object "contact" do |s|
    s.integer "id"
    s.string "name"
    s.integer "age"
    s.uri "homepage"
  end
end
```

As you have probably noticed there is some repetition in this code. To avoid it you can create an helper
like this:

```ruby
# in app/helpers/respect/application_macros.rb
module Respect
  module ApplicationMacros
    def contact_attributes
      string "name"
      integer "age"
      uri "homepage"
    end
  end
end
```

and install this helper in the schema definition DSL like that:

```ruby
# in app/schemas/application_controller_schema.rb
class ApplicationControllerSchema < Respect::Rails::ActionSchema
  helper Respect::ApplicationMacros
end
```

Now the request schema can be rewritten like this:

```ruby
# in ContactsControllerSchema#create
request do
  body_params do |s|
    s.object "contact" do |s|
      s.contact_attributes
    end
  end
end
```

and the response schema like that:

```ruby
# in app/schemas/contacts/create.schema
body_with_object do |s|
  s.object "contact" do |s|
    s.integer "id"
    s.contact_attributes
  end
end
```

This schema definition will serve you in several purposes:

1. To automatically generate a reference documentation of your REST API.
2. To validate the incoming requests and outgoing responses of your Web application.
3. To sanitize incoming parameters.

To get the generated documentation, you only need to mount the Rails engine provided by this library.

```ruby
# in config/routes.rb
mount Respect::Rails::Engine => "/rest_spec"
```

This will add a new `/rest_spec` path under which you have access to your REST API documentation.
In particular `/rest_spec/doc` should render something like that for the "create" request schema:

```json
{
  "type": "object",
  "properties": {
    "contact": {
      "type": "object",
      "required": true,
      "properties": {
        "name": {
          "type": "string",
          "required": true
        },
        "age": {
          "type": "integer",
          "required": true
        },
        "homepage": {
          "type": "string",
          "required": true,
          "format": "uri"
        }
      }
    }
  }
}
```

To validate the request and response with your schema definition, you simply need to add a filter
like this:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :validate_schemas
end
```

The filter searches for a schema associated to a controller's action. If it can find one it validates
and sanitizes the parameters.

If the request's parameters do not validate the schema a `Respect::ValidationError` exception will be
raised before your controller's action is called. If they are valid, they will be sanitized in place.
So the `homepage` parameter will be a `URI` object instead of a simple string:

```ruby
class ContactsController < ApplicationController
  def create
    params["homepage"].is_a?(URI::Generic)              #=> true
  end
end
```

The filter you have just installed is an "around" filter which mean the response will be validated too.
An exception will be raised too. This validation does not happens in production environment, so it will
save you some typing in your tests but does not bother you in production.

# Getting started

The easiest way to install _Respect for Rails_ is to add it to your `Gemfile`:

```ruby
gem "respect-rails", require: "respect/rails"
```

Then, after running the `bundle install` command, you can mount the Rails engine provided by this library
by adding this line at the beginning of your `config/routes.rb` file.

```ruby
mount Respect::Rails::Engine => "/rest_spec"
```

Then, you can start your application web server as usual at point your web browser to
`http://localhost:3000/rest_spec/doc`.

FIXME: speak about generators ?

# Getting help

The easiest way to get help about how to use this library is to post your question on the
[Respect discussion group](FIXME). I will be glade to answer. I may have already answered the
same question so before, you post your question take a bit of time to search the group.

You can also read these documents for further documentation:

* [Respect documentation](FIXME)
* [Repect API reference documentation](FIXME)
* [Repect for Rails API reference documentation](FIXME)
* {file:FAQ.md Frequently Asked Question}

# Coming soon

Many other great features are planned for the next releases. Here a short list of what is coming soon:

* Resource schema: organize your schema as you organize your application resources.
* Generator tasks: template for controller schema, helpers, etc...
* Statistic about how much routes you have documented.
* Rake tasks to quickly access a controller action schema from the terminal.
* A web service to programmatically inspect your API schemas
* A web service to check a request is valid without actually performing the request.
* Specify request and response header
* Try to fetch URL parameters from route's constraints: this may be tricky so no promise.
* Try to fetch resource schema validator from model validator: again this may be tricky so no promise.
* Partial response schema.
* An helper to easily specify nested attributes.

And many more... see the issue tracker with tag FIXME for more information.

# Feedback

I would love to hear what you think about this library. Feel free to post any comments/remarks on the
[Respect discussion group](FIXME).

# Reporting bugs

Even if I prefer patches, I also like bug reports. Feel free to create new issues in this project bug tracker on
GitHub. I will tag them. Before you start just a few reminders:

1. A bug that I can reproduce on my machine is a half-fixed bug. So please, include as much information as you can.
   The best would be to include a failing test or a small ruby script reproducing the bug. If you can't be sure to
   mention the version of Ruby you have used, the full back-trace of the exception if you had one, etc...
1. A documented and tested feature is a half-implemented features. Sometimes English and natural languages in general
   failed to describe your thought precisely. A failing test will mean exactly what you want.
1. Do not post question in the issue trackers. Use the [Respect discussion group](FIXME) instead.

# Contributing patches

I spent quite a lot of time writing this gem but there is still a lot of work to do. Whether it is a bug-fix,
a new feature, some code re-factoring, or documentation clarification, I will be glade to merge your pull request
on GitHub. Before you start a few reminders:

1. Every commits must have a comprehensive commit message.
1. Whenever you are fixing a bug or adding a new features, tests are required.
1. A bit of documentation so that others can understand your code.

Don't worry these rules are not strict. If you can't make it I will be glade to help.

# License

_Respect_ is released under the term of the [MIT License](http://opensource.org/licenses/MIT).
Copyright (c) 2013 Nicolas Despres.

# License

_Respect for Rails_ is released under the term of the [MIT License](http://opensource.org/licenses/MIT)
