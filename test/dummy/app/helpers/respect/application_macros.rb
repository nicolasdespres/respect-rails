module Respect
  # Test module proving that users can easily extend the definition DSL
  # with their own macros bundled in their own modules organized as they
  # want.
  module ApplicationMacros
    def color_channel(name)
      float name, in: 0.0..1.0
    end
  end
end
