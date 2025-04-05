# frozen_string_literal: true

class ShortFormatter
  def initialize(entries)
    @entries = entries
  end

  def generate_content
    max_path_size = @entries.max { |a, b| a.path.size <=> b.path.size }.path.size
    number_of_columns_before_transpose = calc_number_of_rows(max_path_size)

    left_aligned_paths = @entries.map { |entry| entry.path.ljust(max_path_size) }

    rectangular_paths = left_aligned_paths.each_slice(number_of_columns_before_transpose).map do |subset_paths|
      blanks = Array.new(number_of_columns_before_transpose - subset_paths.size, '')
      [*subset_paths, *blanks]
    end

    rectangular_paths.transpose.map do |subset_paths|
      subset_paths.join(' ')
    end.join("\n")
  end

  private

  def calc_number_of_rows(max_path_size)
    current_terminal_width = `tput cols`.to_i

    # number_of_columns * max_path_size + number_of_columns <= current_terminal_width
    number_of_columns = current_terminal_width / (max_path_size + 1)
    (@entries.length / number_of_columns.to_f).ceil
  end
end
