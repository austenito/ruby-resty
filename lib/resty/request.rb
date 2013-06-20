module Resty
  class Request 

    def self.get(url, options = {}, headers = {})
      ppj RestClient.get(url, options.merge(headers))
    end

    def self.ppj(json)
      Ppjson::StreamJsonWriter.new.write(json, pretty: true)
    end
  end
end
