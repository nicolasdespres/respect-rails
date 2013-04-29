# Frequently Asked Question

## Why using Respect for Rails since I do most of my parameters checking in my model?

This is true that complex parameters ckecking/conversions are often done in the model in
order to factor code when multiple endpoints use them. For instance, consider the following
case where the user must provide a circle, via a center point and a radius:

```ruby
class Hotspot < ActiveRecord::Base
  # Returns the list of hot-spots around the given circle.
  #
  # The following statements are equivalent:
  #   Hotspot.around(Circle.new(Point.new(42, 51), 16))
  #   Hotspot.around(center: { x: 42, y: 51 }, radius: 16)
  def self.around(*args)
    if args.is_a? Hash
      # Build a circle from the hash parameters and call this
      # method recursively.
      self.around(Circle.from_h(args.first))
    else
      circle = args.shift
      # Do the query.
    end
  end
end

class HotspotController < ActionController::Base
  def around
    Hotspot.around(params[:area])
  end
end
```

In this case all the sanitization process is handled by the `Circle::from_h` method.  This code
is ok.  However, it has some drawbacks:

1. We still have to write the documentation for the REST API and it would be hard to imagine
   a generator that could understand this code or complex `ActiveRecord` validator code.
1. Although the `Circle::from_h` method may be already provided by a basic third-party library,
   it may not do all the checking necessary when user data come from an HTTP request.
   For instance, it may not handle properly a call like this one:
     `Circle.from_h(center: { x: "foo", y: "bar" }, radius: "invalid")`
1. In case of invalid schema the user may not get an helpful message.  This is perfectly
   acceptable for security reason (see the discussion about error reporting here FIXME).

We can get _Respect for Rails_ do this work for you by adding a helper method which create a
`Circle` object for you when validating the JSON document:

```ruby
module Respect
  class PointSchema < CompositeSchema
    def schema
      ObjectSchema.define do |s|
        s.numeric "x"
        s.numeric "y"
      end
    end

    def sanitize(doc)
      Point.new(doc["x"], doc["y"])
    end
  end

  class CircleSchema < CompositeSchema
    def schema
      ObjectSchema.define do |s|
        s.point "center"
        s.numeric "radius", greater_than: 0
      end
    end

    def sanitize(doc)
      Circle.new(doc[:center], doc[:radius])
    end
  end
end
```

and have your schema written like this

```ruby
class HotspotSchema < Respect::Rails::ActionSchema
  def around
    request do
      schema do |s|
        s.circle "area"
      end
    end
  end
end
```

_Respect for Rails_ does not aim at replacing `ActiveRecord` validator. In other word, some
parameters may be validated by _Respect_ and still generate an `ActiveRecord` error. It is here
to prepare the data for the model, to prevent security issues and to provide a place for
documenting each parameter. See it as a full featured alternative to
[Strong Parameters](https://github.com/rails/strong_parameters).
