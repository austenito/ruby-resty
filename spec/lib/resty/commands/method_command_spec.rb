require 'spec_helper'
require 'json'

describe "MethodCommand" do
  let(:request) { stub }
  let(:response) { stub }
  let(:returned_request) { stub }

  before(:each) do
    Resty::Request.stubs(:new).returns(request)
    Object.any_instance.stubs(:verbose?).returns(false)
  end

  context "command regex" do
    before(:each) do
      request.stubs(:send_request)
    end

    it "responds lower case method" do
      %w{get put post delete head option patch trace}.each do |method|
        pry_eval("#{method}").start_with?("A path").should be_true
      end
    end

    it "responds to case-insentivity" do
      %w{GET Put PoSt delete head option patch trace}.each do |method|
        pry_eval("#{method}").start_with?("A path").should be_true
      end
    end
  end

  context "invalid path" do
    it "doesn't send request" do
      pry_eval("get")
      request.should have_received(:send_request).never
    end
  end

  context "invalid data" do
    context "request requires data" do
      before(:each) do
        pry_eval("post /api/nyan")
      end

      it "never sends request" do
        Resty::Request.should have_received(:new).never
      end
    end

    context "request doesn't require data" do
      before(:each) do
        Resty::Commands::MethodOutput.stubs(:new).returns(stub(:generate))
        Resty::Request.stubs(:new).returns(request)
        request.stubs(:send_request).yields(response, request)
        pry_eval("get /api/nyan")
      end

      it "returns sends request with nil data" do
        params  = { method: "get", path: "/api/nyan", data: nil }
        Resty::Request.should have_received(:new).with(anything, params)
      end
    end
  end

  context "process" do
    let(:method_output) { stub(generate: "")}

    before(:each) do
      Resty::Commands::MethodOutput.stubs(:new).returns(method_output)
      request.stubs(:send_request).yields(response, request)
    end

    context "with data" do
      context "as json string" do
        before(:each) do
          pry_eval("get /api/nyan {\"foo\": \"bar\"}")
        end

        it "creates request" do
          params  = { method: "get", path: "/api/nyan", data: {"foo" => "bar"} }
          Resty::Request.should have_received(:new).with(anything, params)
        end

        it "sends request" do
          Resty::Commands::MethodOutput.should have_received(:new).with(false, response,request)
          method_output.should have_received(:generate)
        end
      end
    end

    context "as ruby hash" do
      before(:each) do
        pry_eval("get /api/nyan {foo: 'bar'}")
      end

      it "creates request" do
        params  = { method: "get", path: "/api/nyan", data: {foo: "bar"} }
        Resty::Request.should have_received(:new).with(anything, params)
      end

      it "sends request" do
        Resty::Commands::MethodOutput.should have_received(:new).with(false, response,request)
        method_output.should have_received(:generate)
      end
    end

    context "as variable" do
      context "with ruby hash" do
        before(:each) do
          Object.any_instance.stubs(:foo).returns(foo: "bar")
          pry_eval("get /api/nyan foo")
        end

        it "creates request" do
          params  = { method: "get", path: "/api/nyan", data: {foo: "bar"} }
          Resty::Request.should have_received(:new).with(anything, params)
        end

        it "sends request" do
          Resty::Commands::MethodOutput.should have_received(:new).with(false, response,request)
          method_output.should have_received(:generate)
        end
      end

      context "with json string" do
        before(:each) do
          Object.any_instance.stubs(:foo).returns('{"foo": "bar"}')
          pry_eval("get /api/nyan foo")
        end

        it "creates request" do
          params  = { method: "get", path: "/api/nyan", data: {"foo" => "bar"} }
          Resty::Request.should have_received(:new).with(anything, params)
        end

        it "sends request" do
          Resty::Commands::MethodOutput.should have_received(:new).with(false, response,request)
          method_output.should have_received(:generate)
        end
      end
    end

    context "without data" do
      before(:each) do
        pry_eval("get /api/nyan")
      end

      it "creates request" do
        params  = { method: "get", path: "/api/nyan", data: nil }
        Resty::Request.should have_received(:new).with(anything, params)
      end

      it "sends request" do
        Resty::Commands::MethodOutput.should have_received(:new).with(false, response,request)
        method_output.should have_received(:generate)
      end
    end
  end
end
