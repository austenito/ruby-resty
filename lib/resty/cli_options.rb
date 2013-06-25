module Resty
  class CliOptions
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def host
      options[:host]
    end

    def verbose?
      options[:verbose] ? true : false
    end

    def headers
      @headers ||=
        if options[:headers]
          options[:headers].inject({}) {|hash, header| hash.merge(build_pair(header)) }
        else
          {}
        end
    end

private

   def build_pair(header)
     pair = header.split("=")
     { pair.first.to_sym => pair.last }
   end
  end
end
