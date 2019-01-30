# encoding: utf-8
require '../helper'

class Param
  class InvalidParam < StandardError
    def initialize(message = '??')
      super("Parameter is invalid: '#{message}'")
    end
  end

  attr_accessor :name, :label, :description, 
      :example, :type, :default, :required
  
  VALID_TYPES = %w(boolean content file number line date page string template url user unknown)

  def initialize(args)
    args.each do |k,v|
      instance_variable_set("@#{k}", v) #unless v.nil?
    end
    
    raise InvalidParam.new("#{@type} is not a valid type") unless (@type.empty? || VALID_TYPES.include?(@type))
    raise InvalidParam.new("#{@required} is not a valid type") unless (@required.empty? || @required == 'true')
  end
  
end