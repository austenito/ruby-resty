require 'readline'
require 'pry'

module Resty
  class Repl
    include Readline

    attr_accessor :cli_options, :request, :printer, :interrupted

    def initialize(cli_options)
      @cli_options = Resty::CliOptions.new(cli_options)
      @request = Resty::Request.new(@cli_options.host, @cli_options.headers)
      @printer = Ppjson::StreamJsonWriter.new

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
        if command.command?
          command.execute
        else
          options = Resty::RequestOptions.new(input)
          if options.valid?
            request.send_request(options) { |response, request, result| display(response, request) }
            Pry.history.push(input)
          else
            puts "Invalid parameters"
          end
        end
      end
      nil
    rescue Interrupt
      self.interrupted = true
      nil
    end

    private

    def display(response, request)
      if cli_options.verbose?
        puts "> #{request.method.upcase} #{request.url}"
        request.processed_headers.each do |key, value|
          puts "> #{key}: #{value}"
        end
        puts ""

        puts "> #{response.code}"
        response.headers.each do |key, value|
          puts "> #{key}: #{value}"
        end
      end

      puts ""
      ppj(response)
    end

    def ppj(json)
      printer.write(json, pretty: true)
    end
  end
end
