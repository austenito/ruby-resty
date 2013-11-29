require 'yaml'

module Resty
  class Options
    attr_reader :options

    CONFIG_FILE = "#{Dir.home}/.ruby_resty.yml"

    def initialize(options)
      @options = options

      if options[:headers]
        options[:headers] = Options.parse_headers(options[:headers])
      elsif host_alias
        load_config_file
      end
    end

    def host
      options[:host]
    end

    def verbose?
      options[:verbose] ? true : false
    end

    def host_alias
      options[:alias]
    end

    def headers
      options[:headers] || {}
    end

    def username
      options[:username]
    end

    def password
      options[:password]
    end

    def self.parse_headers(headers)
      headers.inject({}) { |hash, header| hash.merge(build_pair(header)) }
    end

    def self.build_pair(header)
      split_headers = header.split(":")
      { split_headers.shift.to_sym => split_headers.join(":") }
    end

    private

    def load_config_file
      read_config_file.tap do |config|
        options[:host] = config[host_alias]["host"]
        options[:headers] = config[host_alias]["headers"]
        options[:username] = config[host_alias]["username"]
        options[:password] = config[host_alias]["password"]
      end
    end

    def read_config_file
      if File.exist?(CONFIG_FILE)
        YAML.load_file(CONFIG_FILE).tap { |config| validate_config_entries(config) }
      else
        raise ConfigFileError, "#{CONFIG_FILE} is missing."
      end
    end

    def validate_config_entries(config)
      if config[host_alias]
        unless config[host_alias]["host"]
          raise ConfigFileError, "Host missing from #{CONFIG_FILE}"
        end
      else
        raise ConfigFileError, "Alias missing from #{CONFIG_FILE}: #{host_alias}"
      end
    end
  end

  class ConfigFileError < StandardError; end
end
