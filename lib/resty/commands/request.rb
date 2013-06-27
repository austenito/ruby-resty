module Resty
  module Commands
    class Request < Command

      attr_reader :options

      def initialize(cli_options, input)
        @options = Resty::Commands::RequestOptions.new(input)
        super
      end

      def match?
        (input =~ Resty::Commands::RequestOptions::METHOD_REGEX) == 0
      end

      def execute
        Pry.history.push(input)

        if options.valid?
          send_request { |response, request, result| printer.print_result(response, request) }
        else
          printer.print_invalid_options(options)
        end
      end

      private

      def send_request
        case options.method
        when %r{get|head|delete|options}
          RestClient.send(options.method, url, cli_options.headers) { |*params| yield params }
        else
          RestClient.send(options.method, url, options.data, cli_options.headers) { |*params| yield params }
        end
      end

      def url
        "#{cli_options.host}#{options.path}"
      end
    end
  end
end
