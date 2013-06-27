require 'yaml'

module Resty
  class CliOptions
    attr_reader :options

    CONFIG_FILE = "#{Dir.home}/.ruby_resty.yml"

    def initialize(options)
      @options = options
    end

    def host
      options[:host]
    end

    def verbose?
      options[:verbose] ? true : false
    end

    def config?
      options[:config]
    end

    def headers
      @headers ||=
        if config? && File.exist?(CONFIG_FILE)
          config = YAML.load_file(CONFIG_FILE)
          if config[host]
            config[host]["headers"] || {}
          else
            puts "No known host (#{host}) in #{Dir.home}/.ruby_resty.yml"
          end
        elsif options[:headers]
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
