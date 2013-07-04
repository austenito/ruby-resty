module Resty
  module Commands
    class MethodOutput
      attr_accessor :verbose, :response, :request

      def initialize(verbose, response, request)
        @verbose = verbose
        @response = response
        @request = request
      end

      def generate
        output = ""
        if verbose
            output += build_line("#{request.method.upcase} #{request.url}")
            request.processed_headers.each { |key, value| output += build_line("#{key}: #{value}") }
            output += "\n"

            output += build_line("Response Code: #{response.code}")
            response.headers.each { |key, value| output += build_line("#{key}: #{value}") }
        else
            output += build_line("Response Code: #{response.code}")
        end

        output += pretty_json(response)
      end

      private

      def build_line(line)
        "> #{line}\n"
      end

      def pretty_json(json)
        return json if json == ""
        parsed_json = JSON.parse(json)
        MultiJson.dump(parsed_json, { pretty: true }) || ""
      rescue => e
        ""
      end
    end
  end
end
