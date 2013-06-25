require 'spec_helper'

describe Resty::Request do
  let(:request) { Resty::Request.new("foo.com", { header: "value"}) }

  before(:each) do
    RestClient.stubs(:send)
  end

  context "GET" do 
    let(:options) { stub(method: "get", path: "/api/merchants", data: {}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("get", "foo.com/api/merchants", {header: "value"})
      end
    end
  end

  context "DELETE" do
    let(:options) { stub(method: "delete", path: "/api/merchants", data: {}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("delete", "foo.com/api/merchants", {header: "value"})
      end
    end
  end

  context "HEAD" do
    let(:options) { stub(method: "head", path: "/api/merchants", data: {}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("head", "foo.com/api/merchants", {header: "value"})
      end
    end
  end

  context "OPTIONS" do
    let(:options) { stub(method: "options", path: "/api/merchants", data: {}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("options", "foo.com/api/merchants", {header: "value"})
      end
    end
  end

  context "POST" do
    let(:options) { stub(method: "post", path: "/api/merchants", data: {foo: "bar"}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("post", "foo.com/api/merchants", {foo: "bar"}, {header: "value"})
      end
    end
  end

  context "PUT" do
    let(:options) { stub(method: "put", path: "/api/merchants", data: {foo: "bar"}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("put", "foo.com/api/merchants", {foo: "bar"}, {header: "value"})
      end
    end
  end

  context "PATCH" do
    let(:options) { stub(method: "patch", path: "/api/merchants", data: {foo: "bar"}) }

    context "#send_request" do
      before(:each) do
        request.send_request(options)
      end

      it "sends request" do
        RestClient.should have_received(:send).with("patch", "foo.com/api/merchants", {foo: "bar"}, {header: "value"})
      end
    end
  end
end
