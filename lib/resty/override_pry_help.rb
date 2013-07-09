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
      text = "  #{'help [command]'.ljust(18)} Prints detailed help for a command\n"
      text += commands.map do |command|
        "  #{command.options[:listing].to_s.ljust(18)} #{command.description}"
      end.join("\n")
    end
  end
end
