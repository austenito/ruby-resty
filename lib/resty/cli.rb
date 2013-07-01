require 'trollop'

module Resty
  class Cli

    def run
      p = Trollop::Parser.new do
        opt :alias, "The per-host entry to use in ~/.ruby_resty.yml", type: :string, short: "-a"
        opt :host, "The hostname of the REST service. Ex: http://nyan.cat", type: :string, short: "-h"
        opt :headers, "The headers sent with each request. Ex: X-NYAN-CAT-SECRET-KEY=nyan_nyan",
            type: :strings, short: "-H"
        opt :verbose, "Verbose mode", short: "-v"
      end

      Trollop::with_standard_exception_handling p do
        options = p.parse(ARGV)

        if (options[:alias] && options[:host]) || (options[:alias].nil? && options[:host].nil?)
          puts "Please specify an alias OR a host."
          raise Trollop::HelpNeeded
        elsif options.empty?
          raise Trollop::HelpNeeded
        end

        Resty::Repl.start(options)
      end

    rescue ConfigFileError => e
      puts e.message
    end
  end
end
