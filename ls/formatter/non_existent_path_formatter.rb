# frozen_string_literal: true

class NonExistentPathFormatter
  def initialize(entries)
    @entries = entries
  end

  def generate_content
    @entries.map do |entry|
      "ls: #{entry.display_name}: No such file or directory"
    end.join("\n")
  end
end
