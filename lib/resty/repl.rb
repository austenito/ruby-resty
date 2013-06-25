require 'readline'
require 'pry'

module Resty
  class Repl
    include Readline

    attr_accessor :cli_options, :request, :printer, :interrupted

    def initialize(cli_options)
      @cli_options = Resty::CliOptions.new(cli_options)
      @request = Resty::Request.new(cli_options.host, cli_options.headers)
      @printer = Resty::Printer.new(cli_options.verbose?)

      Pry.config.prompt = [ proc { "resty> " }, proc { "*>" }]
      Pry.config.history.file = "~/.ruby_resty_history"
    end

    def self.start(cli_options)
      new(cli_options).tap do |repl|
        Pry.config.input = repl

        until repl.interrupted
          "".pry
        end
      end
    end

    def readline(current_prompt)
      Readline.readline(current_prompt).tap do |input|
        command = Resty::Command.new(input)
        command.command? ? command.execute : execute_request(input)
      end
      nil
    rescue Interrupt
      self.interrupted = true
      nil
    end

private

    def execute_request(input)
      Resty::RequestOptions.new(input).tap do |options|
        if options.valid?
          request.send_request(options) do |response, request, result|
            printer.print_result(response, request)
          end
          Pry.history.push(input)
        else
          printer.print_invalid_options(options)
        end
      end
    end
  end
end
