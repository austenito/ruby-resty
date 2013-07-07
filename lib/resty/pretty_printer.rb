
module Resty
  class PrettyPrinter
    attr_accessor :params

    def initialize(params)
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

        output += pretty_json(response)
      end
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

    private

    def verbose?
      params[:cli_options].verbose?
    end

    def request
      params[:request]
    end

    def response
      params[:response]
    end
  end
end
