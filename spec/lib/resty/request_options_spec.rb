require 'spec_helper'

require 'spec_helper'

describe Resty::RequestOptions do
  let(:options) { Resty::RequestOptions.new("get /api/cats") }
  let(:data) { { "foo" => "bar" }.to_json }

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
      let(:options) { Resty::RequestOptions.new("get /api/cats #{data}") }

      it "returns hash" do
        expect(options.data).to eq("foo" => "bar")
      end
    end
  end

  context "validate" do
    context "valid options" do
      it "returns true" do
        expect(Resty::RequestOptions.new("get /api/cats #{data}").valid?).to be_true
      end

      context "no data" do
        let(:options) { Resty::RequestOptions.new("get /api/cats") }

        it "returns false" do
          expect(options.valid?).to be_true
        end
      end
    end

    context "invalid method" do
      let(:options) { Resty::RequestOptions.new("foo /api/cats #{data}") }

      it "returns false" do
        expect(options.valid?).to be_false
      end
    end

    context "invalid path" do
      let(:options) { Resty::RequestOptions.new("get ") }

      it "returns false" do
        expect(options.valid?).to be_false
      end
    end

    context "invalid data" do
      let(:options) { Resty::RequestOptions.new("get /api/cats data") }

      it "returns false" do
        expect(options.valid?).to be_false
      end
    end
  end
end
