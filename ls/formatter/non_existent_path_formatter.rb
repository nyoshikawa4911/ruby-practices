# frozen_string_literal: true

class NonExistentPathFormatter
  def initialize(container)
    @container = container
  end

  def generate_content
    @container.entries.sort_by(&:display_name).map do |entry|
      "ls: #{entry.display_name}: No such file or directory"
    end.join("\n") + "\n"
  end
end
