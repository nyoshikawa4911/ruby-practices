# frozen_string_literal: true

class ExistentFilePathContainer
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
