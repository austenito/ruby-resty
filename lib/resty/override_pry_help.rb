class Pry
  class Command::Help < Pry::ClassCommand
    COMMANDS = %w{method-command}

    def visible_commands
      visible = {}
      commands.each do |key, command|
        visible[key] = command if COMMANDS.include?(command.options[:listing])
      end
      visible
    end

    def help_text_for_commands(name, commands)
      commands.first.banner
    end
  end
end
