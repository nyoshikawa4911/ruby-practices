# frozen_string_literal: true

require_relative 'container_statistics'
require_relative '../entry'

class ExistentFilePathContainer
  include ContainerStatistics

  attr_reader :entries

  def initialize(paths)
    @paths = paths
    @entries = generate_entries
  end

  private

  def generate_entries
    @entries = @paths.map { |path| Entry.new(path) }
  end
end
