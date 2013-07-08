require 'json'

module Resty
  class Request

    attr_reader :params, :options

    def initialize(options, params)
      @options = options
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
      request_options = { method: method, headers: options.headers, url: url }
      request_options[:user] = options.username if options.username
      request_options[:password] = options.password if options.password
      request_options[:payload] = data if Resty::Request.data_required?(method)
      @request ||= RestClient::Request.new(request_options)
    end

    def url
      "#{options.host}#{path}"
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
