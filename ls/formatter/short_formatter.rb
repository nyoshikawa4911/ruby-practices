# frozen_string_literal: true

class ShortFormatter
  def initialize(entries)
    @entries = entries
  end

  def generate_content
    max_name_size = @entries.max { |a, b| a.display_name.size <=> b.display_name.size }.display_name.size
    number_of_columns_before_transpose = calc_number_of_rows(max_name_size)

    left_aligned_names = @entries.map { |entry| entry.display_name.ljust(max_name_size) }

    rectangular_names = left_aligned_names.each_slice(number_of_columns_before_transpose).map do |subset_names|
      blanks = Array.new(number_of_columns_before_transpose - subset_names.size, '')
      [*subset_names, *blanks]
    end

    rectangular_names.transpose.map do |subset_names|
      subset_names.join(' ')
    end.join("\n")
  end

  private

  def calc_number_of_rows(max_name_size)
    current_terminal_width = `tput cols`.to_i

    # number_of_columns * max_name_size + number_of_columns <= current_terminal_width
    number_of_columns = current_terminal_width / (max_name_size + 1)
    (@entries.length / number_of_columns.to_f).ceil
  end
end
