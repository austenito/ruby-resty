require 'json'

module Resty
  class Request

    attr_reader :params, :cli_options

    def initialize(cli_options, params)
      @cli_options = cli_options
      @params = params
    end

    def send_request(request_headers = {})
      request.execute { |*params| yield params }
    end

    def self.data_required?(method)
      (method =~ %r{put|post|patch}) == 0
    end

    private

    def request
      return @request if @request
      options = { method: method, headers: cli_options.headers, url: url }
      options[:user] = cli_options.username if cli_options.username
      options[:password] = cli_options.password if cli_options.password
      options[:payload] = data if Resty::Request.data_required?(method)
      @request ||= RestClient::Request.new(options)
    end

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
