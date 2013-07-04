require 'json'

module Resty
  class Request

    attr_reader :params, :cli_options

    def initialize(cli_options, params)
      @cli_options = cli_options
      @params = params
    end

    def send_request
      if Resty::Request.data_required?(method)
        RestClient.send(method, url, data, cli_options.headers) { |*params| yield params }
      else
        RestClient.send(method, url, cli_options.headers) { |*params| yield params }
      end
    end

    def self.data_required?(method)
      (method =~ %r{put|post|patch}) == 0
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
      params[:data]
    end
  end
end
