# Respect plugin for Rails

_Respect for Rails_ let's you write the documentation of your REST API using Ruby code. Your app's
API is published using a Rails engine so it is always deployed along with your application and stay
synchronized. A filter is available so you can also easily validate requests and responses. Thanks
to that your incoming parameters will also be sanitized so if you expect a URI in a parameter value you will get a URI object instead of a string object containing a URI.
It follows Rails DRY principle and save you a lot of typing since it
fetches most of the information automatically by inspecting your routes, their constraints and your
model validators. You can always adjust the default by defining the schema per resource and/or
controller.

# Features

* Based on [Respect](https://github.com/nicolasdespres/respect) to compactly specify the content
  of the headers and parameters of your requests and the headers and the body of your responses.
* Controllers' helpers to automatically validates and sanitize incoming parameters.
* A Rails engine to mount in your application to publish your public REST API documentation.
  * Your documentation will always be up to date with your application.
  * Access the full API documentation.
  * Deployed transparently with your application so you don't have to worry about it.
* A DSL to specify your controllers' actions schema (URL, body, headers).
* Generated documentation follows [JSON schema standard](http://json-schema.org/) as much as
  possible. It currently follows the
  [draft v3](http://tools.ietf.org/id/draft-zyp-json-schema-03.html) standard version.
* Routes are automatically collected.

Coming soon:

* Describe the schema of your resources.
* Use routes' constraints as default request's path parameters validation rules.
* Use models' validators as default request's body parameters validation rules.
* Generator tasks: helpers, etc...
* Statistic about how much routes you have documented.
* Rake tasks to quickly access a controller action schema from the terminal.
* A web service to inspect your API schema by code.
* A web service to check a request is valid without actually performing the request.
* An helper to easily specify nested attributes.
* Use markdown in documentation string.
* More appealing documentation rendering.

# Take a tour

_Respect for Rails_ let's you easily describe the structure of incoming requests and outgoing responses
using a simple and compact Ruby DSL. Assuming you have the scaffold of a `ContactsController`, the structure
for its `create` action may look like this:

```ruby
# in app/schemas/contacts_controller_schema.rb
class ContactsControllerSchema < ApplicationControllerSchema
  def create
    request do |r|
      r.headers do |h|
        h["HTTP_VERSION"] = "HTTP/1.1"
      end
      r.body_parameters do |s|
        s.hash "contact" do |s|
          s.string "name"
          s.integer "age"
          s.uri "homepage"
        end
      end
    end
    response_for do |status|
      status.created # contacts/create-created.schema
      status.unprocessable_entity do |s|
        s.body do |s|
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
body do |s|
  s.hash "contact" do |s|
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
request do |r|
  r.headers do |h|
    h["HTTP_VERSION"] = "HTTP/1.1"
  end
  r.body_parameters do |s|
    s.hash "contact" do |s|
      s.contact_attributes
    end
  end
end
```

and the response schema like that:

```ruby
# in app/schemas/contacts/create.schema
body do |s|
  s.hash "contact" do |s|
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
In particular `/rest_spec/doc` should render something like that for the `create` request schema:

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
and sanitizes the parameters incoming parameters.

If the request's parameters/headers do not validate the schema a
`Respect::Rails::RequestValidationError` exception will be raised before your controller's action
is called. If they are valid, they will be
sanitized in place. Thus, the `homepage` parameter will be a `URI` object instead of a simple string:

```ruby
class ContactsController < ApplicationController
  def create
    params["homepage"].is_a?(URI::Generic)              #=> true
  end
end
```

The filter you have just installed is an "around" filter which means the response will be validated too.
Actually, the validation takes place only if the response content type is `application/json`. A
`Respect::Rails::ResponseValidationError` will be raised in case of error. This validation is executed
only in development and test mode, so it won't bother you in production.

Instead of the usual exception reporting view, you can get a dedicated one for
`Respect::Rails::RequestValidationError` in development mode. You just have to add something like that
to your `ApplicationController`:

```ruby
rescue_from_request_validation_error
```

This helper can render the error in both HTML and JSON.

A response validation error handler is also available but only in development. In test mode the exception
would be raised as usual.

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

# Compatibility

_Respect for Rails_ has been tested with:

* Ruby 1.9.3-p392 (should be compatible with all 1.9.x family)
* Rails 3.2.13
* Respect 0.1.0

Note that it uses `ActiveSupport::JSON` to encode/decode JSON objects.

# Feedback

I would love to hear what you think about this library. Feel free to post any comments/remarks on the
[Respect discussion group](FIXME).

# Contributing patches

I spent quite a lot of time writing this gem but there is still a lot of work to do. Whether it
is a bug-fix, a new feature, some code re-factoring, or documentation clarification, I will be
glade to merge your pull request on GitHub. You just have to create a branch from `master` and
send me a pull request.

# License

_Respect for Rails_ is released under the term of the [MIT License](http://opensource.org/licenses/MIT).
Copyright (c) 2013 Nicolas Despres.
