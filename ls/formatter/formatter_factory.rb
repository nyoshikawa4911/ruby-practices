# frozen_string_literal: true

require_relative '../optional_argument'
require_relative '../container/non_existent_path_container'
require_relative 'non_existent_path_formatter'
require_relative 'long_formatter'
require_relative 'short_formatter'

class FormatterFactory
  def self.create(container)
    if container.instance_of?(NonExistentPathContainer)
      NonExistentPathFormatter.new(container.entries)
    elsif OptionalArgument.instance.long_format?
      LongFormatter.new(container.entries)
    else
      ShortFormatter.new(container.entries)
    end
  end
end
