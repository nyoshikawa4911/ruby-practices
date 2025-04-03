# frozen_string_literal: true

require 'singleton'
require 'optparse'

class OptionalArgument
  include Singleton

  def initialize
    arguments = ARGV.getopts('arl')
    @all = arguments['a']
    @reverse = arguments['r']
    @long = arguments['l']
  end

  def self.setup
    instance
  end

  def show_all? = @all

  def reverse_order? = @reverse

  def long_format? = @long
end
