# frozen_string_literal:true

require 'minitest/autorun'
require_relative '../calendar'

class CalendarTest < Minitest::Test
  def test_weeks_starting_sunday
    calendar = Calendar.new(2024, 12)
    expected = [
      ' 1  2  3  4  5  6  7',
      ' 8  9 10 11 12 13 14',
      '15 16 17 18 19 20 21',
      '22 23 24 25 26 27 28',
      '29 30 31            ',
      '                    '
    ]
    assert_equal expected, calendar.weeks
  end

  def test_weeks_starting_saturday
    calendar = Calendar.new(2024, 6)
    expected = [
      '                   1',
      ' 2  3  4  5  6  7  8',
      ' 9 10 11 12 13 14 15',
      '16 17 18 19 20 21 22',
      '23 24 25 26 27 28 29',
      '30                  '
    ]
    assert_equal expected, calendar.weeks
  end

  def test_weeks_last_two_rows_are_blank
    calendar = Calendar.new(2015, 2)
    expected = [
      ' 1  2  3  4  5  6  7',
      ' 8  9 10 11 12 13 14',
      '15 16 17 18 19 20 21',
      '22 23 24 25 26 27 28',
      '                    ',
      '                    '
    ]
    assert_equal expected, calendar.weeks
  end

  def test_weeks_february_in_leap_years
    calendar = Calendar.new(2024, 2)
    expected = [
      '             1  2  3',
      ' 4  5  6  7  8  9 10',
      '11 12 13 14 15 16 17',
      '18 19 20 21 22 23 24',
      '25 26 27 28 29      ',
      '                    '
    ]
    assert_equal expected, calendar.weeks
  end

  def test_generate_oldest_month
    calendar = Calendar.new(1, 1)
    expected = [
      '        1月 1',
      '日 月 火 水 木 金 土',
      '                   1',
      ' 2  3  4  5  6  7  8',
      ' 9 10 11 12 13 14 15',
      '16 17 18 19 20 21 22',
      '23 24 25 26 27 28 29',
      '30 31'
    ].join("\n")
    assert_equal expected, calendar.generate
  end

  def test_generate_latest_month
    calendar = Calendar.new(9999, 12)
    expected = [
      '      12月 9999',
      '日 月 火 水 木 金 土',
      '          1  2  3  4',
      ' 5  6  7  8  9 10 11',
      '12 13 14 15 16 17 18',
      '19 20 21 22 23 24 25',
      '26 27 28 29 30 31',
      ''
    ].join("\n")
    assert_equal expected, calendar.generate
  end
end
