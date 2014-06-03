module Respect
  class Schema
    # Explain the options of this schema to humans.
    def explain_options(options = {})
      # Collect options to explain.
      if options[:only]
        names = options[:only]
      elsif options[:except]
        names = options.keys.select{|name| options[:except].include?(name) }
      else
        names = options.keys
      end
      # Explain options
      result = []
      names.each do |name|
        desc = explain_option(name)
        result << desc if desc
      end
      result
    end

    # Explain the option called +name+ to humans.
    # Returns +nil+ if there is no explanation.
    def explain_option(name)
      case name
      when :required, :default
        if required?
          "Is required."
        else
          if has_default?
            "Is optional and default value is #{default.inspect}."
          else
            "Is optional."
          end
        end
      when :allow_nil
        allow_nil? ? "May be null." : nil;
      when :doc
        nil
      else
        if explanation = explain_validator(name, options[name])
          explanation
        else
          "Option #{name} has value '#{options[name].inspect}'."
        end
      end
    end

    private

    def explain_validator(name, value)
      if validator_class = Respect.validator_for(name)
        validator = validator_class.new(options[name])
        if validator.respond_to?(:explain)
          validator.explain
        else
          nil
        end
      end
    end
  end # class Schema

  class HashSchema < Schema
    # Overwritten method. See {Schema#explain_option}.
    def explain_option(name)
      case name
      when :strict
        "Must contains exactly the defined properties."
      else
        super
      end
    end
  end # class HashSchema

  class ArraySchema < Schema
    # Overwritten method. See {Schema#explain_option}.
    def explain_option(name)
      case name
      when :uniq
        "All items must be uniq."
      else
        super
      end
    end
  end # class ArraySchemaq

  class Validator
    # Explain this validator to humans.
    # Returns +nil+ if there is no explanation.
    def explain
      nil
    end
  end # class Validator

  class MultipleOfValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be a multiple of #@divider."
    end
  end # class MultipleOfValidator

  class MinLengthValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be at least #@min_length long."
    end
  end # class MinLengthValidator

  class MaxLengthValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be at worst #@max_length long."
    end
  end # class MaxLengthValidator

  class MatchValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must match #{@pattern.inspect}."
    end
  end # class MatchValidator

  class LessThanValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be less than #@max."
    end
  end # class LessThanValidator

  class LessThanOrEqualValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be less than or equal to #@max."
    end
  end # class LessThanOrEqualValidator

  class InValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      case @set
      when Range
        "Must be between #{@set.min} and #{@set.max}."
      when Enumerable
        "Must be equal to #{@set.to_sentence(last_word_conntect: " or ")}."
      else
        "Must be in #{@set.inspect}."
      end
    end
  end # class InValidator

  class GreaterThanValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be greater than #@min."
    end
  end # class GreaterThanValidator

  class GreaterThanOrEqualValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be greater or equal to #@min."
    end
  end # class GreaterThanOrEqualValidator

  class FormatValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      case @format
      when :email
        "Must be a valid email address."
      when :uri
        "Must be a valid URI."
      when :regexp
        "Must be a valid regular expression."
      when :datetime
        "Must be a valid date and time (according to RFC 3339)."
      when :ipv4_addr
        "Must be a valid IPv4 address."
      when :ipv6_addr
        "Must be a valid IPv6 address."
      when :phone_number
        "Must be a valid phone number."
      when :ip_addr
        "Must be a valid IPv4 or IPv6 address."
      when :hostname
        "Must be a valid host name."
      else
        "Must have format #@format."
      end
    end
  end # class FormatValidator

  class EqualToValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be equal to #@expected."
    end
  end # class EqualToValidator

  class DivisibleByValidator < Validator
    # Overwritten method. See {Validator#explain}.
    def explain
      "Must be divisible by #@divider."
    end
  end # class DivisibleByValidator

end # module Respect
