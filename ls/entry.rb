# frozen_string_literal: true

class Entry
  attr_reader :display_name

  def initialize(path, display_name = nil)
    @display_name = display_name || path
    @stat = File::Stat.new(path) if File.exist?(path)
  end
end
