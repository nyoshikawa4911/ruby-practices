#!/usr/bin/env ruby
# frozen_string_literal:true

require 'optparse'
require_relative 'calendar'
require_relative 'annual_calendar'

options = {}
option_parser = OptionParser.new
option_parser.on('-y VAL', Integer) do |year|
  options[:year] = year
end
option_parser.on('-m VAL', Integer) do |month|
  options[:month] = month
end
option_parser.parse!

if options[:year] && !options[:month]
  puts AnnualCalendar.new(options[:year]).generate
else
  now = Time.now
  puts Calendar.new(options[:year] || now.year, options[:month] || now.month).generate
end
