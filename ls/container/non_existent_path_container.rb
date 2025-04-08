# frozen_string_literal: true

require_relative '../entry'
class NonExistentPathContainer
  attr_reader :entries

  def initialize(paths)
    @paths = paths
    @entries = generate_entries
  end

  private

  def generate_entries
    @entries = @paths.sort.map { |path| Entry.new(path) }
  end
end
