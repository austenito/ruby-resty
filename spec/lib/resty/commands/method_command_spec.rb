require 'spec_helper'
require 'json'

describe "MethodCommand" do
  before(:each) do
    Resty::Request.stubs(:new).returns(request)
  end

  context "command regex" do
    let(:request) { stub(path_valid?: false) }

    it "responds lower case method" do
      %w{get put post delete head option patch trace}.each do |method|
        pry_eval(method)
      end
      Resty::Request.should have_received(:new).times(8)
    end

    it "responds to case-insentivity" do
      %w{GET Put PoSt delete head option patch trace}.each do |method|
        pry_eval(method)
      end
      Resty::Request.should have_received(:new).times(8)
    end
  end

  context "process" do
    context "invalid path" do
      let(:request) { stub(path_valid?: false) }

      it "doesn't send request" do
        pry_eval("get")
        request.should have_received(:send_request).never
      end
    end

    context "invalid data" do
      let(:request) { stub(path_valid?: :true, data_valid?: false) }

      it "doesn't send request" do
        pry_eval("get")
        request.should have_received(:send_request).never
      end
    end
    
    context "valid arguments" do
      let(:response) { stub }
      let(:request) { stub(path_valid?: :true, data_valid?: true) }
      let(:params) { { method: "get", path: "/api/nyan", data: "#{JSON.dump(foo: 'bar')}"} }
      let(:method_output) { stub(generate: "")}

      before(:each) do
        Resty::Commands::MethodOutput.stubs(:new).returns(method_output)
        Object.any_instance.stubs(:verbose?).returns(false)
        request.stubs(:send_request).yields(response, request)
        pry_eval("get /api/nyan '#{JSON.dump(foo: 'bar')}'")
      end

      it "creates request" do
        Resty::Request.should have_received(:new).with(anything, params)
      end

      it "sends request" do
        Resty::Commands::MethodOutput.should have_received(:new).with(false, response,request)
      end

      it "generates output" do
        method_output.should have_received(:generate)
      end
    end
  end
end
