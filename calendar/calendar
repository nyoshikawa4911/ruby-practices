#!/usr/bin/env ruby
# frozen_string_literal:true

require 'optparse'
require_relative 'calendar'
require_relative 'annual_calendar'

options = {}
option_parser = OptionParser.new
option_parser.on('-m MONTH', Integer) do |month|
  raise OptionParser::InvalidArgument, month if !month.nil? && !(1..12).cover?(month)

  options[:month] = month
end
option_parser.on('-y [YEAR]', Integer) do |year|
  if year.nil?
    options[:year] = Time.now.year
  else
    raise OptionParser::InvalidArgument, year unless (1..9999).cover?(year)

    options[:year] = year
  end
end

argv = []
begin
  argv = option_parser.parse!(ARGV)
rescue OptionParser::InvalidArgument => e
  abort "Error: Month '#{e.args[1]}' must be an integer between 1 and 12" if e.args[0] == '-m'
  abort "Error: Year '#{e.args[1]}' must be an integer between 1 and 9999" if e.args[0] == '-y'
rescue OptionParser::MissingArgument => e
  abort "Error: Argument is missing #{e.args[0]}"
end

abort 'Error: Option -m and -y cannot be specified together' if options[:year] && options[:month]

if options[:year]
  abort 'Error: Too many arguments for -y (Only one argument is allowed)' unless argv.empty?
  puts AnnualCalendar.new(options[:year]).generate
  exit
end

if options[:month]
  abort 'Error: Too many arguments for -m　(Only month and year are allowed)' if argv.size > 1
  abort "Error: Year '#{argv[0]}' must be an integer between 1 and 9999" if !argv[0].nil? && (!argv[0].match?(/^\d+$/) || !(1..9999).cover?(argv[0].to_i))
end

puts Calendar.new(argv[0]&.to_i || Time.now.year, options[:month] || Time.now.month).generate
