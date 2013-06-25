require 'spec_helper'

describe Resty::CliOptions do
  let(:options) {
    Resty::CliOptions.new(host: "foo.com",
                       headers: ["key=star", "type=ninja"])
  }

  it "returns host" do
    expect(options.host).to eq("foo.com")
  end

  it "returns headers" do
    expect(options.headers).to eq(key: "star", type: "ninja")
  end

  context "empty headers" do 
    let(:options) { Resty::CliOptions.new({}) }

    it "returns empty hash" do
      expect(options.headers).to eq({})
    end
  end
end
