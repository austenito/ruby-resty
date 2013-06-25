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

  context "#method_valid?" do
    it "returns true with valid methods" do
      %w{get put post delete head option patch}.each do |method|
        options = Resty::RequestOptions.new("#{method} /api/cats")
        expect(options.method_valid?).to be_true
      end
    end

    it "returns false" do
      options = Resty::RequestOptions.new("foo /api/cats")
      expect(options.method_valid?).to be_false
    end
  end

  context "#path_valid?" do
    it "returns true" do
      options = Resty::RequestOptions.new("get /api/cats")
      expect(options.path_valid?).to be_true
    end

    it "returns false" do
      options = Resty::RequestOptions.new("get")
      expect(options.path_valid?).to be_false
    end
  end

  context "#data_valid?" do
    it "returns true with data" do
      options = Resty::RequestOptions.new("get /api/cats #{data}")
      expect(options.data_valid?).to be_true
    end

    it "returns true with blank data" do
      options = Resty::RequestOptions.new("get /api/cats ")
      expect(options.data_valid?).to be_true
    end

    it "returns false" do
      options = Resty::RequestOptions.new("get /api/cats data")
      expect(options.data_valid?).to be_false
    end
  end

  context "#valid?" do
    it "returns true" do
      expect(Resty::RequestOptions.new("get /api/cats #{data}").valid?).to be_true
    end

    it "returns false with invalid method" do
      expect(Resty::RequestOptions.new("foo /api/cats #{data}").valid?).to be_false
    end

    it "returns false with invalid path" do
      expect(Resty::RequestOptions.new("foo").valid?).to be_false
    end

    it "returns false with invalid method" do
      expect(Resty::RequestOptions.new("foo /api/cats data").valid?).to be_false
    end
  end
end
