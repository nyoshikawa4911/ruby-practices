# frozen_string_literal: true

class LongFormatter
  def initialize(container)
    @container = container
  end

  def generate_content
    delimiter = ' '
    @container.entries.map do |entry|
      [
        entry.mode,
        entry.extended_attribute + delimiter,
        entry.nlink.to_s.rjust(@container.max_nlink_digits) + delimiter,
        entry.owner_name.ljust(@container.max_owner_name_length) + delimiter * 2,
        entry.group_name.ljust(@container.max_group_name_length) + delimiter * 2,
        entry.file_size.to_s.rjust(@container.max_file_size_digits) + delimiter,
        format_modified_date(entry.modified_date) + delimiter,
        entry.display_name
      ].join
    end.join("\n")
  end

  private

  def format_modified_date(date)
    if date.year == Time.now.year
      date.strftime('%_2m %_2d %H:%M')
    else
      date.strftime('%_2m %_2d  %Y')
    end
  end
end
