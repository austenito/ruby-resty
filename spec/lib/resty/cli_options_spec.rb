require 'spec_helper'

describe Resty::CliOptions do
  context "command line options" do
    let(:options) { Resty::CliOptions.new(host: "foo.com", headers: ["key=star", "type=ninja"],
                                          username: "leeroy", password: "jenkins", alias: "nyan") }

    it "returns host" do
      expect(options.host).to eq("foo.com")
    end

    it "returns headers" do
      expect(options.headers).to eq(key: "star", type: "ninja")
    end

    it "doesn't read config file" do
      options.should have_received(:load_config_file).never
    end

    it "returns username" do
      expect(options.username).to eq("leeroy")
    end

    it "returns password" do
      expect(options.password).to eq("jenkins")
    end

    context "empty headers" do 
      let(:options) { Resty::CliOptions.new({}) }

      it "returns empty hash" do
        expect(options.headers).to eq({})
      end
    end
  end

  context "config file" do
    context "all values exist" do
      before(:each) do
        YAML.stubs(:load_file).returns({"nyan" => { "host" => "nyan.cat", "username" => "leeroy",
                                                    "headers" => {"header" => "value"},
                                                    "password" => "jenkins"} } )
        File.stubs(:exist?).returns(true)
        @options = Resty::CliOptions.new(alias: "nyan")
      end

      it "returns host" do
        expect(@options.host).to eq("nyan.cat")
      end

      it "returns headers" do
        expect(@options.headers).to eq("header" => "value")
      end

      it "returns username" do
        expect(@options.username).to eq("leeroy")
      end

      it "returns password" do
        expect(@options.password).to eq("jenkins")
      end

      it "loads YAML file" do
        YAML.should have_received(:load_file).with("#{Dir.home}/.ruby_resty.yml")
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
