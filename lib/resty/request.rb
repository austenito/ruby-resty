module Resty
  class Request 

    def self.get(url, options = {}, headers = {})
      RestClient.get(url, options.merge(headers))
    end
  end
end
