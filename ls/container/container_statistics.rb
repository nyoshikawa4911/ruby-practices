# frozen_string_literal: true

module ContainerStatistics
  def max_name_bytesize = @entries.map(&:display_name).max_by(&:bytesize).bytesize

  def max_nlink_digits = @entries.map(&:nlink).max.to_s.length

  def max_owner_name_length = @entries.map(&:owner_name).max_by(&:length).length

  def max_group_name_length = @entries.map(&:group_name).max_by(&:length).length

  def max_file_size_digits = @entries.map(&:file_size).max.to_s.length

  def total_block_size = @entries.sum(&:blocks)
end
