# frozen_string_literal: true

class LongFormatter
  def initialize(container)
    @container = container
  end

  def generate_content
    [
      @container.instance_of?(Directory) ? "total #{@container.total_block_size}\n" : '',
      format_entries
    ].join
  end

  def format_entries
    return '' if @container.entries.empty?

    delimiter = ' '
    sorted_entries.map do |entry|
      [
        entry.mode,
        entry.extended_attribute + delimiter,
        entry.nlink.to_s.rjust(@container.max_nlink_digits) + delimiter,
        entry.owner_name.ljust(@container.max_owner_name_length) + delimiter * 2,
        entry.group_name.ljust(@container.max_group_name_length) + delimiter * 2,
        entry.file_size.to_s.rjust(@container.max_file_size_digits) + delimiter,
        format_modified_date(entry.modified_date) + delimiter,
        format_display_name(entry),
        "\n"
      ].join
    end.join
  end

  private

  def sorted_entries
    if OptionalArgument.instance.reverse_order?
      @container.entries.sort_by(&:display_name).reverse
    else
      @container.entries.sort_by(&:display_name)
    end
  end

  def format_modified_date(date)
    if date.year == Time.now.year
      date.strftime('%_2m %_2d %H:%M')
    else
      date.strftime('%_2m %_2d  %Y')
    end
  end

  def format_display_name(entry)
    if entry.symbolic_link?
      [entry.display_name, '->', entry.symbolic_link].join(' ')
    else
      entry.display_name
    end
  end
end
