#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'optional_argument'

class LS
  def initialize(paths)
    @paths = paths
  end

  def generate
    existing_paths, non_existing_paths = paths.partition { |path| File.exist?(path) }
    directory_paths, file_paths = existing_paths.partition { |path| File.ftype(path) == 'directory' }
  end

  private

  attr_reader :paths
end

OptionalArgument.setup
puts LS.new(ARGV.empty? ? [Dir.pwd] : ARGV).generate
