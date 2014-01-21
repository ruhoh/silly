module Silly
  module QueryOperators
    def self.execute(attribute, value)
      if value.is_a?(Hash)
        type, value = value.to_a.first
      else
        type = "$equals"
        value = value.is_a?(Symbol) ? value.to_s : value
      end

      command = type[1, type.size]

      __send__(command, attribute, value)
    end

    def self.exists(attribute, value)
      !!attribute == !!value
    end

    def self.equals(attribute, value)
      case attribute
      when Array
        attribute.include?(value)
      else
        attribute == value
      end
    end

    def self.ne(attribute, value)
      case attribute
      when Array
        !attribute.include?(value)
      else
        attribute != value
      end
    end

    def self.in(attribute, value)
      value.include?(attribute)
    end

    def self.nin(attribute, value)
      !self.in(attribute, value)
    end

    def self.exclude(attribute, value)
      case attribute
      when Array
        attribute.each{ |a| return false if (a =~ value) }
      else
        !(attribute =~ value)
      end
    end
  end
end
