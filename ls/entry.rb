# frozen_string_literal: true

require 'etc'
require './ext/mac_extended_attribute'
require_relative 'file_mode_formatter'

class Entry
  attr_reader :display_name

  def initialize(path, display_name = nil)
    @display_name = display_name || path
    @path = path
    @stat = File.lstat(path) if File.exist?(path)
  end

  def mode = FileModeFormatter.format(@stat.mode)

  def extended_attribute = MacExtendedAttribute.get_xattr(@path)

  def nlink = @stat.nlink

  def owner_name = Etc.getpwuid(@stat.uid).name

  def group_name = Etc.getgrgid(@stat.gid).name

  def file_size = @stat.size

  def modified_date = @stat.mtime

  def symbolic_link = symbolic_link? ? File.readlink(@path) : nil

  def symbolic_link? = @stat.symlink?

  def blocks = @stat.blocks
end
