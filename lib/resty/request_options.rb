module Resty
  class RequestOptions

    attr_reader :raw_options, :options

    def initialize(raw_options)
      @raw_options = raw_options
      @options = parse_input(raw_options)
    end

    def method
      options[:method].downcase if options[:method]
    end

    def path
      options[:path]
    end

    def data
      JSON.parse(options[:data]) || {} rescue {}
    end

    def valid?
      method_valid? && path_valid? && data_valid?
    end

    def method_valid?
      (method =~ %r{get|put|post|delete|head|option|patch|trace}) == 0
    end

    def path_valid?
      path.nil? ? false : true
    end

    def data_valid?
      JSON.parse(options[:data])
      true
    rescue => e
      false
    end

    private

    def parse_input(input)
      match = input.match(%r{(\w+) ([\w|\/]+)\s?(.*)})

      if match
        groups = match.captures
        {}.tap do |hash|
          hash[:method] = groups[0]
          hash[:path] = groups[1]
          hash[:data] = groups[2]
        end
      else
        {}
      end
    end
  end
end
