# frozen_string_literal: true

class ShortFormatter
  def initialize(container)
    @container = container
  end

  def generate_content
    return '' if @container.entries.empty?

    max_name_width = @container.max_name_bytesize
    column_count_before_transpose = calc_row_count(max_name_width)

    names = @container.entries.map(&:display_name)
    sorted_names = OptionalArgument.instance.reverse_order? ? names.sort.reverse : names.sort
    left_aligned_names = sorted_names.map { |name| ljust_for_display_width(name, max_name_width) }

    rectangular_names = left_aligned_names.each_slice(column_count_before_transpose).map do |subset_names|
      blanks = Array.new(column_count_before_transpose - subset_names.size, '')
      [*subset_names, *blanks]
    end

    rectangular_names.transpose.map do |subset_names|
      "#{subset_names.join(' ').rstrip}\n"
    end.join
  end

  private

  def calc_row_count(name_width)
    current_terminal_width = `tput cols`.to_i

    # number_of_columns * name_width + number_of_columns <= current_terminal_width
    number_of_columns = current_terminal_width / (name_width + 1)
    (@container.entries.length / number_of_columns.to_f).ceil
  end

  def ljust_for_display_width(name, width)
    wide_char_count = name.chars.count { |char| char.match?(/[^ -~｡-ﾟ]/) }
    name.ljust(width - wide_char_count)
  end
end
