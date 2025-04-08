# frozen_string_literal: true

require_relative 'container_statistics'
require_relative '../optional_argument'

class ExistentFilePathContainer
  include ContainerStatistics

  attr_reader :entries

  def initialize(paths)
    @paths = paths
    @entries = generate_entries
  end

  private

  def generate_entries
    sorted_entries = @paths.sort.map { |path| Entry.new(path) }
    @entries = OptionalArgument.instance.reverse_order? ? sorted_entries.reverse : sorted_entries
  end
end
