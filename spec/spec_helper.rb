require_relative "../lib/resty"

require 'mocha/api'
require 'bourne'

require 'pry/test/helper'

RSpec.configure do |c|
  c.mock_with :mocha

  include PryTestHelpers
end

class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end
