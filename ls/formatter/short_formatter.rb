# frozen_string_literal: true

class ShortFormatter
  def initialize(container)
    @container = container
  end

  def generate_content
    max_name_width = @container.max_name_bytesize
    number_of_columns_before_transpose = calc_number_of_rows(max_name_width)

    left_aligned_names = @container.entries.map { |entry| ljust_for_display_width(entry.display_name, max_name_width) }

    rectangular_names = left_aligned_names.each_slice(number_of_columns_before_transpose).map do |subset_names|
      blanks = Array.new(number_of_columns_before_transpose - subset_names.size, '')
      [*subset_names, *blanks]
    end

    rectangular_names.transpose.map do |subset_names|
      subset_names.join(' ')
    end.join("\n")
  end

  private

  def calc_number_of_rows(name_width)
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
