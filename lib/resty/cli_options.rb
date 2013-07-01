require 'yaml'

module Resty
  class CliOptions
    attr_reader :options

    CONFIG_FILE = "#{Dir.home}/.ruby_resty.yml"

    def initialize(options)
      @options = options

      if options[:headers]
        parse_command_line_headers
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

    private

    def parse_command_line_headers
      options[:headers] = options[:headers].inject({}) do |hash, header|
        hash.merge(build_pair(header))
      end
    end

    def load_config_file
      read_config_file.tap do |config|
        options[:host] = config[host_alias]["host"]
        options[:headers] = config[host_alias]["headers"] || {}
      end
    end

    def read_config_file
      if File.exist?(CONFIG_FILE)
        YAML.load_file(CONFIG_FILE).tap do |config|
          if config[host_alias]
            unless config[host_alias]["host"]
              raise ConfigFileError, "Host missing from #{CONFIG_FILE}"
            end
          else
            raise ConfigFileError, "Alias missing from #{CONFIG_FILE}: #{host_alias}"
          end
        end
      else 
        raise ConfigFileError, "#{CONFIG_FILE} is missing."
      end
    end

    def build_pair(header)
      pair = header.split("=")
      { pair.first.to_sym => pair.last }
    end
  end

  class ConfigFileError < StandardError; end
end
