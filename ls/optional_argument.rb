# frozen_string_literal: true

require 'singleton'
require 'optparse'

class OptionalArgument
  include Singleton

  def setup(options)
    return if @initialized

    @all = options['a']
    @reverse = options['r']
    @long = options['l']
    @initialized = true
  end

  def show_all? = @all

  def reverse_order? = @reverse

  def long_format? = @long
end
