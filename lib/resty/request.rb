module Resty
  class Request 

    attr_accessor :host, :headers

    def initialize(host, headers = {})
      @host = host
      @headers = headers
    end

    def send_request(options)
      RestClient.send(options.method, url(options), merge_params(options))
    end

    private

    def url(options)
      "#{host}#{options.path}"
    end

    def merge_params(options)
      {}.tap do |params|
        params[:params] = options.data unless options.data.empty?
        params.merge!(headers)
      end
    end
  end
end
