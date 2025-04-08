# frozen_string_literal: true

class ShortFormatter
  def initialize(container)
    @container = container
  end

  def generate_content
    max_name_length = @container.max_display_name_length
    number_of_columns_before_transpose = calc_number_of_rows(max_name_length)

    left_aligned_names = @container.entries.map { |entry| entry.display_name.ljust(max_name_length) }

    rectangular_names = left_aligned_names.each_slice(number_of_columns_before_transpose).map do |subset_names|
      blanks = Array.new(number_of_columns_before_transpose - subset_names.size, '')
      [*subset_names, *blanks]
    end

    rectangular_names.transpose.map do |subset_names|
      subset_names.join(' ')
    end.join("\n")
  end

  private

  def calc_number_of_rows(max_name_length)
    current_terminal_width = `tput cols`.to_i

    # number_of_columns * max_name_length + number_of_columns <= current_terminal_width
    number_of_columns = current_terminal_width / (max_name_length + 1)
    (@container.entries.length / number_of_columns.to_f).ceil
  end
end
