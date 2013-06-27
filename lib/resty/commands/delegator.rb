module Resty
  module Commands
    class Delegator
      IGNORE_FILES = %w{command delegator request_options}

      attr_accessor :cli_options, :input, :command

      def initialize(cli_options, input)
        @cli_options = cli_options
        @input = input
      end

      def find_command
        files.each do |file|
          constant = ActiveSupport::Inflector.constantize("Resty::Commands::#{file}")
          command = constant.new(cli_options, input)
          self.command = command if command.match?
        end

        self.command
      end

      def execute
        command.execute if command
      end

private

      def files
        @files ||= Dir.glob(File.join(File.dirname(__FILE__), "*.rb")).collect do |file|
          file_name = file.split("/").last.gsub(".rb", "")
          file_name.capitalize unless IGNORE_FILES.include?(file_name)
        end.compact
      end
    end
  end
end
