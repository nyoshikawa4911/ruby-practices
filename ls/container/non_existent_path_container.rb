# frozen_string_literal: true

require_relative '../entry'
class NonExistentPathContainer

  def initialize(paths)
    @paths = paths
  end

  def entries
    @paths.map { |path| Entry.new(path) }
  end
end
