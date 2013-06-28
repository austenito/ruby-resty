require 'json'

module Resty
  class Request

    attr_reader :params, :printer, :cli_options

    def initialize(cli_options, params)
      @cli_options = cli_options
      @params = params
    end

    def send_request
      case method
      when %r{get|head|delete|options}
        RestClient.send(method, url, cli_options.headers) { |*params| yield params }
      else
        RestClient.send(method, url, data, cli_options.headers) { |*params| yield params }
      end
    end

    def path_valid?
      path.nil? ? false : true
    end

    def data_valid?
      JSON.parse(params[:data])
      true
    rescue => e
      false
    end

    private

    def url
      "#{cli_options.host}#{path}"
    end

    def method
      params[:method]
    end

    def path
      params[:path]
    end

    def data
      JSON.parse(params[:data]) || {} rescue {}
    end
  end
end
