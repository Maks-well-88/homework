# frozen_string_literal: true

require_relative 'module_accessors'
require_relative 'module_validation'

class History
  include Accessors
  attr_accessor_with_history :name

  def initialize
    @name = name
  end
end

class Strong
  include Accessors
  strong_attr_accessor :name, String

  def initialize
    @name = name
  end
end

history = History.new
history.name = 'Maksim'
history.name = 'Dasha'
history.name = 'Sasha'
p history.name_history

strong = Strong.new
strong.name = 'Dasha'

class TestValidation
  include Validation

  validate :name, :presence
  validate :number, :format, /[0-9]+/i.freeze
  validate :type, :type, String

  def initialize
    @name = 'Maks'
    @number = '2141412'
    @type = '13'
  end
end

test = TestValidation.new
test.validate!
