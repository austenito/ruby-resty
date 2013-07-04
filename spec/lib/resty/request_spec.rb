require 'spec_helper'

describe Resty::Request do
  let(:cli_options) { stub(host: "foo.com", verbose?: false, headers: { header: "value" }) }

  context "#send_request" do
    before(:each) do
      RestClient.stubs(:send)
    end

    context "GET" do
      let(:params) { { method: "get", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("get", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "DELETE" do
      let(:params) { { method: "delete", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("delete", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "HEAD" do
      let(:params) { { method: "head", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("head", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "OPTIONS" do
      let(:params) { { method: "options", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("options", "foo.com/api/merchants",
                                                    {header: "value"})
      end
    end

    context "PUT" do
      let(:params) { { method: "put", path: "/api/merchants", data: {"foo" => "bar"} } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("put", "foo.com/api/merchants",
                                                    {"foo" => "bar"}, {header: "value"})
      end
    end

    context "POST" do
      let(:params) { { method: "post", path: "/api/merchants", data: {"foo" => "bar"} } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "sends request" do
        RestClient.should have_received(:send).with("post", "foo.com/api/merchants",
                                                    {"foo" => "bar"}, {header: "value"})
      end
    end
  end
end
