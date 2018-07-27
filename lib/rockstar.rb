require 'rockstar/version'
require 'parslet'
require 'rockstar/rockstar_parser'
require 'rockstar/rockstar_transformer'

module Rockstar
  def self.parse(input)
    RockstarParser.new.parse(input)
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end

  def self.transform(tree)
    RockstarTransformer.new.apply(tree)
  end

  def self.transpile(input)
    transform(parse(input))
  end
end
