require 'spec_helper'

require 'spec_helper'

describe Resty::RequestOptions do
  let(:options) { Resty::RequestOptions.new("get /api/cats") }

  it "returns method" do
    expect(options.method).to eq("get")
  end

  it "returns path" do
    expect(options.path).to eq("/api/cats")
  end

  context "#data" do
    context "no data" do
      it "returns empty hash" do
        expect(options.data).to eq({})
      end
    end

    context "with data" do
      let(:data) { { "foo" => "bar" } }
      let(:options) { Resty::RequestOptions.new("get /api/cats #{data.to_json}") }

      it "returns hash" do
        expect(options.data).to eq("foo" => "bar")
      end
    end
  end
end
