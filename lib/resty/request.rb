require 'json'

module Resty
  class Request

    attr_reader :params, :cli_options

    def initialize(cli_options, params)
      @cli_options = cli_options
      @params = params
    end

    def send_request(request_headers = {})
      if Resty::Request.data_required?(method)
        resource.send(method, data) { |*params| yield params }
      else
        resource.send(method) { |*params| yield params }
      end
    end

    def self.data_required?(method)
      (method =~ %r{put|post|patch}) == 0
    end

    private

    def resource
      return @resource if @resource
      options = { headers: cli_options.headers }
      options[:user] = cli_options.username if cli_options.username
      options[:password] = cli_options.password if cli_options.password
      @resource ||= RestClient::Resource.new(url, options)
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
