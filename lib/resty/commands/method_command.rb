require 'hashie'

Pry::Commands.create_command /(get|put|post|delete|head|options|patch)/i,
  listing: "method-command", :keep_retval => true do

  description "Performs an HTTP request to the specified path: METHOD PATH [DATA]"

  banner <<-BANNER
  Performs an HTTP request to the specified path with optional data: METHOD PATH [DATA]

  Examples: 
  --------- 
  GET    /api/nyan
  GET    /api/nyan -H filter:color -H type:space
  DELETE /api/nyan
  PUT    /api/nyan {"name": "Jan"}
  POST   /api/nyan {"name": "Jeff"}

  Ruby hashes can also be used:
  -----------------------------
  PUT  /api/nyan {name: "Jan"}

  And even ruby variables:
  ------------------------
  data = {name: "j3"}
  PUT  /api/nyan data

  BANNER

  command_options(
    shellwords: false
  )

  def setup
    @user_auth = nil
  end

  def process
    if path_missing?
      "Missing path. Type '#{http_method} -h' for more info, or 'help'."
    elsif data_invalid?
      "Invalid data. Type '#{http_method} -h' for more info, or 'help'."
    else
      params = { method: http_method, path: path, data: data }
      request = Resty::Request.new(global_options, params)
      request.send_request({headers: request_headers}) do |response, request|
        eval_response(response)
        return Hashie::Mash.new(response: response, request: request)
      end
    end
  end

  def options(opt)
    opt.on "H=", :headers, "Headers sent per-request. Ex: -H header:value -H header:value",
      as: Array
  end

  private

  def path_missing?
    path.nil?
  end

  def data_invalid?
    data.nil? && Resty::Request.data_required?(http_method)
  end

  def eval_response(response)
    target.eval("response = #{JSON.parse(response)}")
  rescue
    target.eval("response = %q(#{response})")
  end

  def build_data
    return nil unless args[2]

    input = args[2..-1].join(" ")
    parse_json(input) || eval_ruby(input) || nil
  end

  def eval_ruby(input)
    parsed_input = target.eval(input)
    if parsed_input.is_a?(String)
      JSON.parse(parsed_input)
    else
      parsed_input
    end
  rescue
  end

  def parse_json(input)
    JSON.parse(input) rescue nil
  end

  def global_options
    @global_options ||= eval "self", target
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

  def request_headers
    opts[:headers] ? Resty::Options.parse_headers(opts[:headers]) : {}
  end
end
