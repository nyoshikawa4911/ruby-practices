# frozen_string_literal:true

require_relative 'calendar'

class AnnualCalendar
  NUMBER_OF_QUARTER_ROWS = 8 # 月名行 + 曜日行 + 日付行(6)

  attr_reader :year

  def initialize(year)
    @year = year
  end

  def generate
    calendars = (1..12).map { |month| Calendar.new(@year, month) }
    quarterly_displays = calendars.each_slice(3).map do |three_calendars|
      three_calendars.map do |calendar|
        ["#{calendar.month}月".center(Calendar::CALENDAR_WIDTH), Calendar::WEEK_HEADER, *calendar.weeks]
      end
    end
    annual_calendar_rows = quarterly_displays.flat_map do |quarterly_display|
      quarterly_display.transpose.map { |week_cells| week_cells.join('  ') }
    end

    spaced_annual_calendar_rows =
      annual_calendar_rows.each_slice(NUMBER_OF_QUARTER_ROWS).flat_map { |rows| rows + [''] }[0..-2]

    [@year.to_s.center(Calendar::CALENDAR_WIDTH * 3), *spaced_annual_calendar_rows].join("\n")
  end
end
