require 'spec_helper'
require 'json'

describe Resty::Commands::MethodOutput do
  let(:request) { stub }
  let(:response) { JSON.dump({foo: "bar"}) }

  context "#print" do
    before(:each) do
      response.stubs(:code).returns(200)
    end

    context "non-verbose" do
      let(:method_output) { Resty::Commands::MethodOutput.new(false, response, request) }

      it "returns output" do
         output = <<-eos.unindent
           > Response Code: 200
           {
             "foo": "bar"
           }
        eos

        # multi-line text adds an extra \n, so let's ignore it
        method_output.generate.should eq(output[0..-2])
      end
    end

    context "verbose" do
      let(:method_output) { Resty::Commands::MethodOutput.new(true, response, request) }
      
      before(:each) do
        request.stubs(:method).returns("get")
        request.stubs(:url).returns("foo.com")
        request.stubs(:processed_headers).returns(header: "value", header2: "value2")
        response.stubs(:headers).returns(response_header: "value", response_header2: "value2")
      end

      it "returns verbose output" do
         output = <<-eos.unindent
           > GET foo.com
           > header: value
           > header2: value2

           > Response Code: 200
           > response_header: value
           > response_header2: value2
           {
             "foo": "bar"
           }
        eos

        # multi-line text adds an extra \n, so let's ignore it
        method_output.generate.should eq(output[0..-2])
      end
    end
  end
end
