module Resty
  class Command
    COMMANDS = %w{help exit}

    attr_accessor :command

    def initialize(command)
      @command = command
    end

    def execute
      send(command)
    end

    def command?
      COMMANDS.include?(command)
    end

private

    def exit
      raise Interrupt
    end
  end
end
