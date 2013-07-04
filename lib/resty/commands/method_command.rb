Pry::Commands.create_command /(get|put|post|delete|head|option|patch|trace)/i do
  description "Echo the input: echo [ARGS]"

  command_options(
    shellwords: false
  )

  def process
    if path_missing?
      output.puts("A path must be included. Ex: http://nyan.cat/<path>")
    elsif data_invalid?
      output.puts("Invalid data. Check if you have valid JSON at: http://jsonlint.com/")
    else
      params = { method: http_method, path: path, data: data }
      request = Resty::Request.new(cli_options, params)
      request.send_request do |response, request|
        method_output = Resty::Commands::MethodOutput.new(cli_options.verbose?, response, request)
        output.puts(method_output.generate)
      end
    end
  end

  private

  def path_missing?
    path.nil?
  end

  def data_invalid?
    data.nil? && Resty::Request.data_required?(http_method)
  end

  def build_data
    return nil unless args[2]

    input = args[2..-1].join(" ")
    parse_json(input) || eval_ruby(input) || nil
  end

  def eval_ruby(input)
    target.eval(input) rescue nil
  end

  def parse_json(input)
    JSON.parse(input) rescue nil
  end

  def cli_options
    @cli_options ||= eval "self", target
  end

  def http_method
    args[0]
  end

  def path
    args[1]
  end

  def data
    @data ||= build_data
  end
end
