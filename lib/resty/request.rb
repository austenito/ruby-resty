require 'json'

module Resty
  class Request

    attr_reader :params, :global_options

    def initialize(global_options, params)
      @global_options = global_options
      @params = params
    end

    def send_request(options = {})
      request_options[:headers].merge!(options[:headers]) if options[:headers]
      RestClient::Request.new(request_options).execute { |*params| yield params }
    end

    def self.data_required?(method)
      (method =~ %r{put|post|patch}) == 0
    end

    private

    def request_options
      @request_options ||= {}.tap do |options|
        options[:method] = method
        options[:headers] = global_options.headers
        options[:url] = url
        options[:user] = global_options.username if global_options.username
        options[:password] = global_options.password if global_options.password
        options[:payload] = data if Resty::Request.data_required?(method)
      end
    end

    def url
      "#{global_options.host}#{path}"
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
