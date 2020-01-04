class Commander::Parser::LongFlagFormat < Commander::Parser::Base
  protected def match?
    !!PATTERN.match(param)
  end

  protected def parse!
    if contains_equals?
      with_equals
    else
      without_equals
    end
  end

  private def contains_equals?
    !!EQUALS_PATTERN.match(param)
  end

  private def with_equals
    parts = param.split('=')
    key = parts[0]
    value = parts[1..-1].join('=')

    missing_argument!(param) if value == ""

    if flag = flags.find_long(key)
      if flag.type == Bool
        doesnt_take_arguments!(flag.long)
      end

      options.set(flag.name, flag.cast(value))
      return true
    end

    options.set(key, value)
  end

  private def without_equals
    if flag = flags.find_long(param)
      if flag.type == Bool
        options.set(flag.name, !flag.default)
        return true
      else
        if value = next_param
          options.set(flag.name, flag.cast(value))
          skip_next.call
          return true
        else
          puts "Error"
          missing_argument!(param)
        end
      end
    end

    key = param
    value = next_param

    options.set(key, value)
  end
end
