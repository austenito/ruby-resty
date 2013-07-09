require 'trollop'

module Resty
  class Cli

    def run
      options = Trollop::options do
        version "Version: #{Resty::VERSION}\n"
        opt :alias, "The per-host entry to use in ~/.ruby_resty.yml", type: :string, short: "-a"
        opt :headers, "The headers sent with each request. Ex: X-NYAN-CAT-SECRET-KEY:nyan_nyan",
          type: :strings, short: "-H"
        opt :host, "The hostname of the REST service. Ex: http://nyan.cat", type: :string, short: "-h"
        opt :username, "HTTP basic authentication username", type: :string, short: "-u"
        opt :password, "HTTP basic authentication password", type: :string, short: "-p"
        opt :verbose, "Verbose mode", short: "-v"
      end

      if missing_host_or_alias?(options)
        puts "Please specify an alias OR a host. Use --help for more info."
      elsif basic_auth_invalid?(options)
        puts "Please specify a username and password. Use --help for more info."
      else
        Resty::Repl.start(options)
      end

    rescue ConfigFileError => e
      puts e.message
    end

    def missing_host_or_alias?(options)
      (options[:alias] && options[:host]) || (options[:alias].nil? && options[:host].nil?)
    end

    def basic_auth_invalid?(options)
      username = options[:username]
      password = options[:password]
      (username && password.nil?) || (username.nil? && password)
    end
  end
end
