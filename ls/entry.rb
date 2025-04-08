# frozen_string_literal: true

require 'etc'
require_relative 'file_mode_formatter'

class Entry
  attr_reader :display_name

  def initialize(path, display_name = nil)
    @display_name = display_name || path
    @stat = File::Stat.new(path) if File.exist?(path)
  end

  def mode = FileModeFormatter.format(@stat.mode)

  def extended_attribute
    # todo 拡張属性の取得
    ' '
  end

  def nlink = @stat.nlink

  def owner_name = Etc.getpwuid(@stat.uid).name

  def group_name = Etc.getgrgid(@stat.gid).name

  def file_size = @stat.size

  def modified_date = @stat.mtime
end
