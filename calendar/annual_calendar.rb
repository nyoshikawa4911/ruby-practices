# frozen_string_literal:true

require_relative 'calendar'

class AnnualCalendar
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def generate
    calendars = (1..12).map { |month| Calendar.new(@year, month) }
    quarterly_displays = calendars.each_slice(3).map do |three_calendars|
      three_calendars.map do |calendar|
        ["#{calendar.month}月".center(CALENDAR_WIDTH), WEEK_HEADER, *calendar.weeks]
      end
    end
    annual_calendar_rows = quarterly_displays.flat_map do |quarterly_display|
      quarterly_display.transpose.map { |week_cells| week_cells.join('  ') }
    end

    spaced_annual_calendar_rows = annual_calendar_rows.each_slice(8).flat_map { |rows| rows + [''] }[0..-2]

    [@year.to_s.center(CALENDAR_WIDTH * 3), *spaced_annual_calendar_rows].join("\n")
  end
end
