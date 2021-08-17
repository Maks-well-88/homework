# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def self.extended(base)
      class << base; attr_accessor :data_store, :name end
    end

    def validate(name, valid_type, param = nil)
      @data_store ||= []
      @data_store.push({ name: name, valid_type: valid_type, param: param })
    end
  end

  module InstanceMethods
    def validate!
      self.class.data_store.each do |action|
        send(action[:valid_type].to_sym, action[:name], action[:param])
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def get_name(name)
      instance_variable_get("@#{name}".to_sym)
    end

    def presence(name, _)
      raise('Атрибут nil или пустой') if get_name(name).nil? || get_name(name).eql?('')
    end

    def format(name, param)
      get_name(name).match?(param) ? true : raise('Атрибут не соответствует формату')
    end

    def type(name, param)
      get_name(name).is_a?(param) ? true : raise('Атрибут не соответствует типу')
    end
  end
end
