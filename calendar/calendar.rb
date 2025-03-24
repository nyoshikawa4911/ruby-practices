# frozen_string_literal:true

require 'date'

CALENDAR_WIDTH = 20
WEEK_HEADER = '日 月 火 水 木 金 土'
NUMBER_OF_WEEK_ROWS = 6
NUMBER_OF_CALENDAR_CELLS = 7 * NUMBER_OF_WEEK_ROWS
BLANK = '  '

class Calendar
  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
  end

  def weeks
    first_date = Date.new(@year, @month, 1)
    last_date = first_date.next_month.prev_day

    days = (first_date..last_date).map do |date|
      date == Date.today ? "\e[30;47m#{date.strftime('%e')}\e[m" : date.strftime('%e')
    end
    forward_blanks = Array.new(first_date.wday, BLANK)
    backward_blanks = Array.new(NUMBER_OF_CALENDAR_CELLS - forward_blanks.size - days.size, BLANK)
    days_with_blanks = [*forward_blanks, *days, *backward_blanks]
    days_with_blanks.each_slice(7).map { |week| week.join(' ') }
  end

  def generate
    title_header = "#{@month}月 #{@year}".center(CALENDAR_WIDTH)
    [title_header, WEEK_HEADER, *weeks].join("\n")
  end
end
