module Resty
  module Commands
    class Exit < Command
      attr_reader :input

      def initialize(cli_options, input)
        @input = input
        super
      end

      def match?
        input.downcase == "exit" if input
      end

      def execute
        raise Interrupt
      end
    end
  end
end
