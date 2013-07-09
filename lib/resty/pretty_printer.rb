
module Resty
  class PrettyPrinter
    attr_accessor :options, :params

    def initialize(options, params)
      @options = options
      @params = params
    end

    def generate 
      if params.is_a?(String)
        params
      else
        output = ""
        if verbose?
          output += build_line("#{request.method.upcase} #{request.url}")
          request.processed_headers.each { |key, value| output += build_line("#{key}: #{value}") }
          output += "\n"

          output += build_line("Response Code: #{response.code}")
          response.headers.each { |key, value| output += build_line("#{key}: #{value}") }
        else
          output += build_line("Response Code: #{response.code}")
        end

        output += pretty_print_response(response)
      end
    end

    private

    def build_line(line)
      "> #{line}\n"
    end

    def pretty_print_response(response)
      return response if response == ""
      parsed_response = JSON.parse(response)
      MultiJson.dump(parsed_response, { pretty: true }) || ""
    rescue => e
      response
    end

    private

    def verbose?
      options.verbose?
    end

    def request
      params[:request]
    end

    def response
      params[:response]
    end
  end
end
