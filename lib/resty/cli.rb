require 'trollop'

module Resty
  class Cli

    def run
      p = Trollop::Parser.new do
        opt :host, "The hostname of the REST service. Ex: http://nyan.cat", type: :string, short: "-h"
        opt :headers, "The headers sent with each request. Ex: X-NYAN-CAT-SECRET-KEY=nyan_nyan",
            type: :strings, short: "-H"
        opt :config, "Use host information from ~/.ruby_resty.yml", short: "-c"
        opt :verbose, "Verbose mode", short: "-v"
      end

      Trollop::with_standard_exception_handling p do
        options = p.parse(ARGV)
        raise Trollop::HelpNeeded if options.empty? || options[:host].nil?
        Resty::Repl.start(options)
      end
    end
  end
end
