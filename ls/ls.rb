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
    sorted_directory_paths = OptionalArgument.instance.reverse_order? ? directory_paths.sort.reverse : directory_paths.sort
    sorted_directory_paths.each { |path| containers << Directory.new(path) }

    containers.each_with_object([]) do |container, result|
      formatter = FormatterFactory.create(container)
      content = []
      content << "#{container.path}:\n" if containers.size > 1 && container.instance_of?(Directory)
      content << formatter.generate_content
      result << if container.instance_of?(NonExistentPathContainer) && containers.size > 1
                  content.join.chomp
                else
                  content.join
                end
    end.join("\n")
  end

  private

  attr_reader :paths
end

options = ARGV.getopts('arl')
OptionalArgument.instance.setup(options)
puts LS.new(ARGV.empty? ? [Dir.pwd] : ARGV).generate
