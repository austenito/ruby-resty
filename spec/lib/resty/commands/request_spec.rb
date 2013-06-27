require 'spec_helper'

describe Resty::Commands::Request do
  let(:printer) { stub }
  let(:cli_options) { stub(host: "foo.com", verbose?: false, headers: { header: "value" }) }
  let(:response) { stub }
  let(:result) { stub }
  let(:request) { Resty::Commands::Request.new(cli_options, "") }

  context "#valid?" do
    it "returns true" do
      request = Resty::Commands::Request.new(cli_options, "get")
      expect(request.match?).to be_true
    end

    it "returns false" do
      request = Resty::Commands::Request.new(cli_options, "")
      expect(request.match?).to be_false
    end
  end

  context "#execute" do
    before(:each) do
      RestClient.stubs(:send).yields(response, request, result)
      printer.stubs(:print_result)
      printer.stubs(:print_invalid_options)
      request.stubs(:printer).returns(printer)
    end

    context "invalid request" do
      it "prints error" do
        request.execute
        printer.should have_received(:print_invalid_options).with(request.options)
      end
    end

    context "GET" do
      before(:each) do
        request.stubs(:options).returns(stub(method: "get", path: "/api/merchants", valid?: true))
        request.execute
      end

      it "sends request" do
        RestClient.should have_received(:send).with("get", "foo.com/api/merchants", {header: "value"})
      end

      it "prints result" do
        printer.should have_received(:print_result).with(response, request)
      end
    end

    context "DELETE" do
      before(:each) do
        request.stubs(:options).returns(stub(method: "delete", path: "/api/merchants", valid?: true))
        request.execute
      end

      it "sends request" do
        RestClient.should have_received(:send).with("delete", "foo.com/api/merchants", {header: "value"})
      end

      it "prints result" do
        printer.should have_received(:print_result).with(response, request)
      end
    end

    context "HEAD" do
      before(:each) do
        request.stubs(:options).returns(stub(method: "head", path: "/api/merchants", valid?: true))
        request.execute
      end

      it "sends request" do
        RestClient.should have_received(:send).with("head", "foo.com/api/merchants", {header: "value"})
      end

      it "prints result" do
        printer.should have_received(:print_result).with(response, request)
      end
    end

    context "OPTIONS" do
      before(:each) do
        request.stubs(:options).returns(stub(method: "options", path: "/api/merchants", valid?: true))
        request.execute
      end

      it "sends request" do
        RestClient.should have_received(:send).with("options", "foo.com/api/merchants", {header: "value"})
      end

      it "prints result" do
        printer.should have_received(:print_result).with(response, request)
      end
    end

    context "PUT" do
      before(:each) do
        request.stubs(:options).returns(stub(method: "put", path: "/api/merchants",
                                             data: {"foo" => "bar"}, valid?: true))
        request.execute
      end

      it "sends request" do
        RestClient.should have_received(:send).with("put", "foo.com/api/merchants", {"foo" => "bar"}, {header: "value"})
      end

      it "prints result" do
        printer.should have_received(:print_result).with(response, request)
      end
    end

    context "POST" do
      before(:each) do
        request.stubs(:options).returns(stub(method: "post", path: "/api/merchants",
                                             data: {"foo" => "bar"}, valid?: true))
        request.execute
      end

      it "sends request" do
        RestClient.should have_received(:send).with("post", "foo.com/api/merchants", {"foo" => "bar"}, {header: "value"})
      end

      it "prints result" do
        printer.should have_received(:print_result).with(response, request)
      end
    end
  end
end
