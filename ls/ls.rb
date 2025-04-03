#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'optional_argument'
require_relative 'container/directory'
require_relative 'container/existent_file_path_container'
require_relative 'container/non_existent_path_container'
require_relative 'formatter/formatter_factory'

class LS
  def initialize(paths)
    @paths = paths
  end

  def generate
    existing_paths, non_existing_paths = paths.partition { |path| File.exist?(path) }
    directory_paths, file_paths = existing_paths.partition { |path| File.ftype(path) == 'directory' }

    containers = []
    containers << NonExistentPathContainer.new(non_existing_paths) unless non_existing_paths.empty?
    containers << ExistentFilePathContainer.new(file_paths) unless file_paths.empty?
    directory_paths.each { |path| containers << Directory.new(path) }

    containers.map do |container|
      formatter = FormatterFactory.create(container)
      formatter.generate_content
    end.join("\n")

  end

  private

  attr_reader :paths
end

OptionalArgument.setup
puts LS.new(ARGV.empty? ? [Dir.pwd] : ARGV).generate
