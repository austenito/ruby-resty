require 'spec_helper'

describe Resty::Request do
  let(:options) { Resty::Options.new(host: "foo.com", headers: ["header:value"]) }

  context "#send_request" do
    let(:request) { stub(:execute) }

    before(:each) do
      RestClient::Request.stubs(:new).returns(request)
    end

    context "HTTP method without body" do
      let(:params) { { method: "get", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(options, params).send_request
      end

      it "creates request" do
        RestClient::Request.should have_received(:new).with(url: "foo.com/api/merchants",
                                                            method: "get",
                                                            headers: {header: "value"})
      end

      it "sends request" do
        request.should have_received(:execute)
      end
    end

    context "HTTP method with body" do
      let(:params) { { method: "post", path: "/api/merchants", data: {"foo" => "bar"} } }

      before(:each) do
        Resty::Request.new(options, params).send_request
      end

      it "creates resource" do
        RestClient::Request.should have_received(:new).with(url: "foo.com/api/merchants",
                                                            method: "post",
                                                            payload: {"foo" => "bar"},
                                                            headers: {header: "value"})
      end

      it "sends request" do
        request.should have_received(:execute)
      end
    end

    context "with basic authentication" do
      let(:options) { Resty::Options.new(host: "foo.com", headers: ["header:value"],
                                                username: "leeroy", password: "jenkins") }
      let(:params) { { method: "get", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(options, params).send_request(foo: "bar")
      end

      it "creates request" do
        RestClient::Request.should have_received(:new).with(url: "foo.com/api/merchants",
                                                            method: "get",
                                                            user: "leeroy",
                                                            password: "jenkins",
                                                            headers: {header: "value"})
      end

      it "sends request" do
        request.should have_received(:execute)
      end
    end

    #context "with request options" do
      #let(:params) { { method: "get", path: "/api/merchants" } }

      #before(:each) do
        #Resty::Request.new(options, params).send_request(foo: "bar")
      #end

      #it "creates request" do
        #RestClient::Request.should have_received(:new).with("foo.com/api/merchants",
                                                             #headers: {header: "value"})
      #end

      #it "sends request" do
        #request.should have_received(:send).with("get")
      #end
    #end
  end
end
