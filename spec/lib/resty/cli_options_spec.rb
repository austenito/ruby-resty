require 'spec_helper'

describe Resty::CliOptions do

  context "#host" do
    let(:options) { Resty::CliOptions.new(host: "foo.com") }

    it "returns host" do
      expect(options.host).to eq("foo.com")
    end
  end

  context "#headers" do
    context "config file" do
      let(:options) { Resty::CliOptions.new(host: "foo.com", config: true) }

      context "headers exist" do
        before(:each) do
          File.stubs(:exist?).returns(true)
          YAML.stubs(:load_file).returns({"foo.com" => { "headers" => { "header" => "value" } } })
          @headers = options.headers
        end

        it "returns headers" do
          expect(@headers).to eq("header" => "value")
        end

        it "loads YAML file" do
          YAML.should have_received(:load_file).with("#{Dir.home}/.ruby_resty.yml")
        end
      end

      context "headers don't exist" do
        before(:each) do
          File.stubs(:exist?).returns(true)
          YAML.stubs(:load_file).returns({"foo.com" => {}})
          @headers = options.headers
        end

        it "returns headers" do
          expect(@headers).to eq({})
        end

      end
    end

    context "command line headers" do
      let(:options) { Resty::CliOptions.new(host: "foo.com", headers: ["key=star", "type=ninja"]) }

      it "returns headers" do
        expect(options.headers).to eq(key: "star", type: "ninja")
      end
    end
  end

  context "empty headers" do 
    let(:options) { Resty::CliOptions.new({}) }

    it "returns empty hash" do
      expect(options.headers).to eq({})
    end
  end
end
