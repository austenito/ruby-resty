require 'spec_helper'

describe Resty::Commands::Request do
  let(:cli_options) { stub(host: "foo.com", verbose?: false, headers: { header: "value" }) }
  #let(:request) { Resty::Commands::Request.new(cli_options, "") }

  #context "#valid?" do
    #it "returns true" do
      #request = Resty::Commands::Request.new(cli_options, "get")
      #expect(request.match?).to be_true
    #end

    #it "returns false" do
      #request = Resty::Commands::Request.new(cli_options, "")
      #expect(request.match?).to be_false
    #end
  #end

  #context "#execute" do
    #before(:each) do
      #RestClient.stubs(:send).yields(response, request, result)
      #printer.stubs(:print_result)
      #printer.stubs(:print_invalid_options)
      #request.stubs(:printer).returns(printer)
    #end

    #context "invalid request" do
      #it "prints error" do
        #request.execute
        #printer.should have_received(:print_invalid_options).with(request.options)
      #end
    #end

    context "#send_request" do
      before(:each) do
        RestClient.stubs(:send)
      end

    context "GET" do
      let(:params) { { method: "get", path: "/api/merchants" } }

      before(:each) do
        Resty::Commands::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("get", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "DELETE" do
      let(:params) { { method: "delete", path: "/api/merchants" } }

      before(:each) do
        Resty::Commands::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("delete", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "HEAD" do
      let(:params) { { method: "head", path: "/api/merchants" } }

      before(:each) do
        Resty::Commands::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("head", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "OPTIONS" do
      let(:params) { { method: "options", path: "/api/merchants" } }

      before(:each) do
        Resty::Commands::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("options", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "PUT" do
      let(:params) { { method: "put", path: "/api/merchants", data: "{foo: 'bar'}" } }

      before(:each) do
        Resty::Commands::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("put", "foo.com/api/merchants",
                                                    {foo: "bar"}, {header: "value"})
      end
    end

    context "POST" do
      let(:params) { { method: "post", path: "/api/merchants", data: "{foo: 'bar'}" } }

      before(:each) do
        Resty::Commands::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("post", "foo.com/api/merchants",
                                                    {foo: "bar"}, {header: "value"})
      end
    end
  end
end
