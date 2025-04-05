# frozen_string_literal: true

require_relative '../optional_argument'

class Directory
  def initialize(path)
    @path = path
  end

  def entries
    all_entries = Dir.entries(@path).map { |entry| Entry.new(entry) }
    filtered_entries = OptionalArgument.instance.show_all? ? all_entries : all_entries.filter { |entry| !entry.path[0].eql?('.') }
    sorted_entries = filtered_entries.sort_by(&:path)
    OptionalArgument.instance.reverse_order? ? sorted_entries.reverse : sorted_entries
  end
end
