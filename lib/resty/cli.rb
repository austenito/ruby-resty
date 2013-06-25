require 'trollop'

module Resty
  class Cli

    def run
      p = Trollop::Parser.new do
        opt :host, "The hostname. Ex: http://google.com", type: :string
        opt :headers, "The headers. Ex: http://google.com", type: :strings, short: "-h"
        opt :verbose, "Verbose mode", short: "-v"
      end

      options = Trollop::with_standard_exception_handling p do
        raise Trollop::HelpNeeded if ARGV.empty?
        p.parse ARGV
      end
      Resty::Repl.start(options)
    end
  end
end
