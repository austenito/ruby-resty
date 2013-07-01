require 'spec_helper'

describe Resty::CliOptions do

  context "#host" do
    let(:options) { Resty::CliOptions.new(host: "foo.com") }

    it "returns host" do
      expect(options.host).to eq("foo.com")
    end
  end

  context "#headers" do
    context "with command-line headers" do
      let(:options) { Resty::CliOptions.new(host: "foo.com", headers: ["key=star", "type=ninja"], 
                                            alias: "nyan") }

      it "returns headers" do
        expect(options.headers).to eq(key: "star", type: "ninja")
      end

      it "doesn't read config file" do
        options.should have_received(:load_config_file).never
      end
    end

    context "empty headers" do 
      let(:options) { Resty::CliOptions.new({}) }

      it "returns empty hash" do
        expect(options.headers).to eq({})
      end
    end
  end

  context "alias" do
    context "alias exists" do
      context "headers exist" do
        before(:each) do
          YAML.stubs(:load_file).returns({"nyan" => { "host" => "nyan.cat", 
                                                      "headers" => { "header" => "value" } } })
          File.stubs(:exist?).returns(true)
          @options = Resty::CliOptions.new(alias: "nyan")
        end

        it "returns host" do
          expect(@options.host).to eq("nyan.cat")
        end

        it "returns headers" do
          expect(@options.headers).to eq("header" => "value")
        end

        it "loads YAML file" do
          YAML.should have_received(:load_file).with("#{Dir.home}/.ruby_resty.yml")
        end
      end
    end

    context "headers don't exist" do
      before(:each) do
        YAML.stubs(:load_file).returns({"nyan" => { "host" => "nyan.cat" } } )
        File.stubs(:exist?).returns(true)
        @options = Resty::CliOptions.new(alias: "nyan")
      end

      it "returns host" do
        expect(@options.host).to eq("nyan.cat")
      end

      it "returns headers" do
        expect(@options.headers).to eq({})
      end

      it "loads YAML file" do
        YAML.should have_received(:load_file).with("#{Dir.home}/.ruby_resty.yml")
      end
    end

    context "config file doesn't exist" do
      it "raises ConfigFileError" do
        File.stubs(:exist?).returns(false)
        expect { Resty::CliOptions.new(alias: "nyan") }.to raise_error(Resty::ConfigFileError)
      end
    end

    context "alias doesn't exist" do
      it "raises ConfigFileError" do
        YAML.stubs(:load_file).returns({"ice_cream" => {} } )
        File.stubs(:exist?).returns(true)
        expect { Resty::CliOptions.new(alias: "nyan") }.to raise_error(Resty::ConfigFileError)
      end
    end

    context "host doesn't exist" do
      it "raises error" do
        YAML.stubs(:load_file).returns({"nyan" => {}})
        File.stubs(:exist?).returns(true)
        expect { Resty::CliOptions.new(alias: "nyan") }.to raise_error(Resty::ConfigFileError)
      end
    end
  end
end
