# frozen_string_literal:true

require 'date'

class Calendar
  CALENDAR_WIDTH = 20
  WEEK_HEADER = '日 月 火 水 木 金 土'
  NUMBER_OF_WEEK_ROWS = 6
  NUMBER_OF_CALENDAR_CELLS = 7 * NUMBER_OF_WEEK_ROWS
  BLANK = '  '

  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
  end

  def weeks
    first_date = Date.new(@year, @month, 1)
    last_date = first_date.next_month.prev_day

    days = (first_date..last_date).map do |date|
      formatted_date = date.strftime('%e')
      date == Date.today ? "\e[30;47m#{formatted_date}\e[m" : formatted_date
    end
    forward_blanks = Array.new(first_date.wday, BLANK)
    backward_blanks = Array.new(NUMBER_OF_CALENDAR_CELLS - forward_blanks.size - days.size, BLANK)

    [*forward_blanks, *days, *backward_blanks].each_slice(7).map { |week| week.join(' ') }
  end

  def generate
    title_header = "#{@month}月 #{@year}".center(CALENDAR_WIDTH)
    [title_header, WEEK_HEADER, *weeks].map(&:rstrip).join("\n")
  end
end
