module Resty
  module Commands
    class Command

      attr_accessor :cli_options, :input, :printer

      def initialize(cli_options, input)
        @cli_options = cli_options
        @input = input
        @printer = Resty::Printer.new(cli_options.verbose?)
      end
    end
  end
end
