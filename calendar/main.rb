#!/usr/bin/env ruby
# frozen_string_literal:true

require 'optparse'
require_relative 'calendar'

options = {}
option_parser = OptionParser.new
option_parser.on('-y VAL', Integer) do |year|
  options[:year] = year
end
option_parser.on('-m VAL', Integer) do |month|
  options[:month] = month
end
option_parser.parse!
abort '-yオプションは-mオプションと一緒に指定して下さい' if options[:year] && !options[:month]

now = Time.now
puts Calendar.new(options[:year] || now.year, options[:month] || now.month).generate
