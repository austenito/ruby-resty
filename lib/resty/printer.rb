module Resty
  class Printer
    attr_reader :json_printer, :verbose

    def initialize(verbose = false)
      @verbose = verbose
      @json_printer = Ppjson::StreamJsonWriter.new
    end

    def print_result(response, request)
      if verbose
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

      pretty_print_json(response)
    end

    def print_invalid_options(options)
      if !options.path_valid?
        msg = "A path must be included. Ex: http://nyan.cat/<path>"
      elsif !options.method_valid?
        msg = "Bad method. Support methods: GET PUT POST DELETE PATCH OPTIONS HEAD"
      elsif !options.data_valid?
        msg = "Invalid data. Check if you have valid JSON at: http://jsonlint.com/"
      end
      puts msg
    end

private

    def pretty_print_json(json)
      json_printer.write(json, pretty: true)
    end
  end
end
