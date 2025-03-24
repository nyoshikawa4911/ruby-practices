#!/usr/bin/env ruby
# frozen_string_literal:true

require 'optparse'
require 'date'

CALENDAR_WIDTH = 20
WEEK_HEADER = '日 月 火 水 木 金 土'
NUMBER_OF_WEEK_ROWS = 6
NUMBER_OF_CALENDAR_CELLS = 7 * NUMBER_OF_WEEK_ROWS
BLANK = '  '

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
first_date = Date.new(options[:year] || now.year, options[:month] || now.month, 1)
last_date = first_date.next_month.prev_day

days = (first_date..last_date).map do |date|
  date == Date.today ? "\e[30;47m#{date.strftime('%e')}\e[m" : date.strftime('%e')
end
forward_blanks = Array.new(first_date.wday, BLANK)
backward_blanks = Array.new(NUMBER_OF_CALENDAR_CELLS - forward_blanks.size - days.size, BLANK)
days_with_blanks = [*forward_blanks, *days, *backward_blanks]
weeks = days_with_blanks.each_slice(7).map { |week| week.join(' ') }

rows = ["#{first_date.month}月 #{first_date.year}".center(CALENDAR_WIDTH)]
rows.push(WEEK_HEADER)
rows.push(*weeks)

puts rows
