require 'readline'
require 'pry'

module Resty
  class Repl
    include Readline

    attr_accessor :cli_options, :request, :printer

    def initialize(cli_options)
      @cli_options = Resty::CliOptions.new(cli_options)
      @request = Resty::Request.new(@cli_options.host, @cli_options.headers)
      @printer = Ppjson::StreamJsonWriter.new

      Pry.config.prompt = [ proc { "resty> " }, proc { "*>" }]
    end

    def self.start(cli_options)
      new(cli_options).tap do |repl|
        Pry.config.input = repl

        while true
          "".pry
        end
      end
    end

    def readline(current_prompt)
      Readline.readline(current_prompt).tap do |input|
        options = Resty::RequestOptions.new(input)
        ppj(request.send_request(options))
      end
      nil
    end

private

    def ppj(json)
      printer.write(json, pretty: true)
    end
  end
end
