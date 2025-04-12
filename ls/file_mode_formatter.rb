# frozen_string_literal: true

module FileModeFormatter
  # ref: # Reference: https://github.com/torvalds/linux/blob/master/include/uapi/linux/stat.h
  module FileTypeFormatter
    S_IFMT   = 0o0170000 # bit mask for file type bit field
    S_IFSOCK = 0o0140000 # socket
    S_IFLNK  = 0o0120000 # symbolic link
    S_IFREG  = 0o0100000 # regular file
    S_IFBLK  = 0o0060000 # block device
    S_IFDIR  = 0o0040000 # directory
    S_IFCHR  = 0o0020000 # character device
    S_IFIFO  = 0o0010000 # FIFO

    def self.file_type_char(mode)
      case mode & S_IFMT
      when S_IFSOCK then 's'
      when S_IFLNK  then 'l'
      when S_IFREG  then '-'
      when S_IFBLK  then 'b'
      when S_IFDIR  then 'd'
      when S_IFCHR  then 'c'
      when S_IFIFO  then 'p'
      else '?'
      end
    end
  end

  module PermissionFormatter
    # S_IRWXU = 0o0700 # bit mask for owner permission
    S_IRUSR = 0o0400 # readable for owner
    S_IWUSR = 0o0200 # writable for owner
    S_IXUSR = 0o0100 # executable for owner
    # S_IRWXG = 0o0070 # bit mask for group permission
    S_IRGRP = 0o0040 # readable for group
    S_IWGRP = 0o0020 # writable for group
    S_IXGRP = 0o0010 # executable for group
    # S_IRWXO = 0o0007 # bit mask for other permission
    S_IROTH = 0o0004 # readable for other
    S_IWOTH = 0o0002 # writable for other
    S_IXOTH = 0o0001 # executable for other

    def self.permission_string(mode)
      owner_permission_map = { S_IRUSR => 'r', S_IWUSR => 'w', S_IXUSR => 'x' }
      group_permission_map = { S_IRGRP => 'r', S_IWGRP => 'w', S_IXGRP => 'x' }
      other_permission_map = { S_IROTH => 'r', S_IWOTH => 'w', S_IXOTH => 'x' }

      build_permission_chars = lambda do |permission_map|
        permission_map.each_with_object([]) do |(mask, permission_char), chars|
          chars << ((mode & mask).zero? ? '-' : permission_char)
        end.join
      end

      [
        build_permission_chars.call(owner_permission_map),
        build_permission_chars.call(group_permission_map),
        build_permission_chars.call(other_permission_map)
      ].join
    end
  end

  def self.format(mode)
    [
      FileTypeFormatter.file_type_char(mode),
      PermissionFormatter.permission_string(mode)
    ].join
  end
end
