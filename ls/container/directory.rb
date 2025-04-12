# frozen_string_literal: true

require_relative 'container_statistics'
require_relative '../optional_argument'
require_relative '../entry'

class Directory
  include ContainerStatistics

  attr_reader :path, :entries

  def initialize(path)
    @path = path
    @entries = generate_entries
  end

  private

  def generate_entries
    all_entries = Dir.entries(@path).map { |entry_name| Entry.new([@path, entry_name].join('/'), entry_name) }
    @entries = OptionalArgument.instance.show_all? ? all_entries : all_entries.filter { |entry| !entry.display_name[0].eql?('.') }
  end
end
