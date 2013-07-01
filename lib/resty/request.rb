require 'json'

module Resty
  class Request

    attr_accessor :data, :data_valid
    attr_reader :params, :printer, :cli_options

    def initialize(cli_options, params)
      @cli_options = cli_options
      @params = params
      @data_valid = false
      load_data
    end

    def send_request
      if data_required?
        RestClient.send(method, url, data, cli_options.headers) { |*params| yield params }
      else
        RestClient.send(method, url, cli_options.headers) { |*params| yield params }
      end
    end

    def path_valid?
      path.nil? ? false : true
    end

    def data_valid?
      data_valid
    end

    def data_required?
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

    def load_data
      self.data = JSON.parse(params[:data]) || {}
      self.data_valid = true
    rescue => e
      self.data = {}
    end
  end
end
