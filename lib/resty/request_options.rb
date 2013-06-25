module Resty
  class RequestOptions
    attr_reader :options

    def initialize(options)
      @options = parse_input(options)
    end

    def method
      options[:method].downcase
    end

    def path
      options[:path]
    end

    def data
      JSON.parse(options[:data]) || {} rescue {}
    end

    private

    def parse_input(input)
      regex = %r{(\w+) ([\w|\/]+)\s?(.*)}
      groups = input.match(regex).captures
      {}.tap do |hash|
        hash[:method] = groups[0]
        hash[:path] = groups[1]
        hash[:data] = groups[2]
      end
    end
  end
end
