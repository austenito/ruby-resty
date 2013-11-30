require 'readline'

module Resty
  class Repl
    include Readline
    include Pry::Helpers::BaseHelpers

    attr_accessor :options, :interrupted

    def initialize(resty_options)
      @options = Resty::Options.new(resty_options)

      Pry.config.prompt = [ proc { "resty> " }, proc { "*>" }]
      Pry.config.history.file = "~/.ruby_resty_history"
      Pry.config.print = proc do |output, value|
        output = Resty::PrettyPrinter.new(options, value).generate
        begin
          output.is_a?(String) ? stagger_output(output) : stagger_output(output.pretty_inspect)
        rescue Exception
          output.puts(output)
        end
      end
    end

    def self.start(resty_options)
      new(resty_options).tap do |repl|
        Pry.config.input = repl
        repl.options.pry
      end
    end

    def readline(current_prompt)
      Readline.readline(current_prompt)
    end
  end
end
