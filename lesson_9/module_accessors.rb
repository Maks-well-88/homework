# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def self.extended(base)
      class << base; attr_accessor :history end
    end

    def attr_accessor_with_history(*arguments)
      @history ||= {}
      arguments.each do |argument|
        var = "@#{argument}".to_sym
        define_method(argument.to_sym) { instance_variable_get(var) }
        save_history(argument, history)
        show_history(argument, history)
      end
    end

    def strong_attr_accessor(argument, class_type)
      define_method(argument.to_sym) { instance_variable_get("@#{argument}".to_sym) }
      check_type(argument, class_type)
    end

    def save_history(argument, history)
      define_method("#{argument}=") do |value|
        instance_variable_set("@#{argument}".to_sym, value)
        history[argument] ||= []
        history[argument].empty? ? history[argument] = [value] : history[argument] << value
      end
    end

    def show_history(argument, history)
      define_method("#{argument}_history") { history[argument] }
    end

    def check_type(argument, class_type)
      define_method("#{argument}=") do |value|
        if value.is_a?(class_type)
          instance_variable_set("@#{argument}".to_sym, value)
        else
          raise('Неверный тип данных.') unless value.is_a?(class_type)
        end
      end
    end
  end
end
