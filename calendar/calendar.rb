# frozen_string_literal:true

require 'date'

CALENDAR_WIDTH = 20
WEEK_HEADER = '日 月 火 水 木 金 土'
NUMBER_OF_WEEK_ROWS = 6
NUMBER_OF_CALENDAR_CELLS = 7 * NUMBER_OF_WEEK_ROWS
BLANK = '  '

class Calendar
  def initialize(year, month)
    @year = year
    @month = month
  end

  def generate
    first_date = Date.new(@year, @month, 1)
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
    rows.join("\n")
  end
end
