require 'readline'
require 'pry'

module Resty
  class Repl
    include Readline

    attr_accessor :cli_options, :interrupted

    def initialize(resty_options)
      @cli_options = Resty::CliOptions.new(resty_options)

      Pry.config.prompt = [ proc { "resty> " }, proc { "*>" }]
      Pry.config.history.file = "~/.ruby_resty_history"
    end

    def self.start(resty_options)
      new(resty_options).tap do |repl|
        Pry.config.input = repl

        until repl.interrupted
          "".pry
        end
      end
    end

    def readline(current_prompt)
      Readline.readline(current_prompt).tap do |input|
        delegator = Resty::Commands::Delegator.new(cli_options, input)
        if delegator.find_command
          delegator.execute
        else
          puts "Invalid Command"
        end
      end
      nil
    rescue Interrupt
      self.interrupted = true
      nil
    end
  end
end
