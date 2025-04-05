# frozen_string_literal: true

class ExistentFilePathContainer
  def initialize(paths)
    @paths = paths
  end

  def entries
    @paths.map { |path| Entry.new(path) }
  end
end
