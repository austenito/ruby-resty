require 'readline'
require 'pry'

module Resty
  class Repl
    include Readline

    attr_accessor :options, :interrupted

    def initialize(resty_options)
      @options = Resty::Options.new(resty_options)

      Pry.config.prompt = [ proc { "resty> " }, proc { "*>" }]
      Pry.config.history.file = "~/.ruby_resty_history"
      Pry.config.print = proc do |output, value|
        output.puts(Resty::PrettyPrinter.new(options, value).generate)
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
