require 'spec_helper'

describe Resty::Request do
  let(:cli_options) { stub(host: "foo.com", verbose?: false, headers: { header: "value" }) }

  context "#send_request" do
    let(:resource) { stub(send: "") }
    before(:each) do
      RestClient::Resource.stubs(:new).returns(resource)
    end

    context "HTTP method without body" do
      let(:params) { { method: "get", path: "/api/merchants" } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "creates resource" do
        RestClient::Resource.should have_received(:new).with("foo.com/api/merchants",
                                                             headers: {header: "value"})
      end

      it "sends request" do
        resource.should have_received(:send).with("get")
      end
    end

    context "HTTP method with body" do
      let(:params) { { method: "post", path: "/api/merchants", data: {"foo" => "bar"} } }

      before(:each) do
        Resty::Request.new(cli_options, params).send_request
      end

      it "creates resource" do
        RestClient::Resource.should have_received(:new).with("foo.com/api/merchants",
                                                             headers: {header: "value"})
      end

      it "sends request" do
        resource.should have_received(:send).with("post", params[:data])
      end
    end
  end
end
