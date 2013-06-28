module Resty
  module Commands
    Pry::Commands.create_command %r{(get|put|post|delete|head|option|patch|trace)} do
      description "Echo the input: echo [ARGS]"

      def process
        params = { method: args[0], path: args[1], data: args[2..-1].join(" ") }

        Resty::Commands::Request.new(cli_options, params).tap do |request|
          if request.path_valid?
            output.puts("A path must be included. Ex: http://nyan.cat/<path>")
          elsif request.data_valid?
            output.puts("Invalid data. Check if you have valid JSON at: http://jsonlint.com/")
          else
            request.send_request { |response, request| print_result(response, request) }
          end
        end
      end

      private

      def cli_options
        @cli_options ||= eval "self", target
      end

      def print_result(response, request)
        if cli_options.verbose?
          print_line("#{request.method.upcase} #{request.url}")
          request.processed_headers.each { |key, value| print_line("#{key}: #{value}") }
          output.puts ""

          print_line("Response Code: #{response.code}")
          response.headers.each { |key, value| print_line("#{key}: #{value}") }
        end

        pretty_print_json(response)
      end

      private

      def print_line(line)
        output.puts "> #{line}"
      end

      def pretty_print_json(json)
        return if json == ""
        parsed_json = JSON.parse(json)
        json_printer.write(json, pretty: true)
      rescue
        output.puts(json)
      end
    end
  end
end
