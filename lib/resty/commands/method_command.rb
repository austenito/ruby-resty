Pry::Commands.create_command /(get|put|post|delete|head|option|patch|trace)/i do
  description "Echo the input: echo [ARGS]"

  def process
    params = { method: args[0], path: args[1], data: data(args) }

    Resty::Request.new(cli_options, params).tap do |request|
      if !request.path_valid?
        output.puts("A path must be included. Ex: http://nyan.cat/<path>")
      elsif request.data_required? && !request.data_valid?
        output.puts("Invalid data. Check if you have valid JSON at: http://jsonlint.com/")
      else
        request.send_request do |response, request|
          method_output = Resty::Commands::MethodOutput.new(cli_options.verbose?, response, request)
          output.puts(method_output.generate)
        end
      end
    end
  end

  private

  def data(args)
    args[2] ? args[2..-1].join(" ") : ""
  end

  def cli_options
    @cli_options ||= eval "self", target
  end
end
