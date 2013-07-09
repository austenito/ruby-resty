require 'spec_helper'
require 'json'

describe Resty::PrettyPrinter do
  let(:request) { stub }

  context "#generate" do
    context "JSON response" do
      let(:response) { JSON.dump({foo: "bar"}) }

      before(:each) { response.stubs(:code).returns(200) }

      context "non-verbose" do
        let(:printer) { Resty::PrettyPrinter.new(stub(verbose?: false),
                                                 response: response, request: request) }

        it "returns output" do
          output = <<-eos.unindent
           > Response Code: 200
           {
             "foo": "bar"
           }
          eos

          # multi-line text adds an extra \n, so let's ignore it
          printer.generate.should eq(output[0..-2])
        end
      end

      context "verbose" do
        let(:printer) { Resty::PrettyPrinter.new(stub(verbose?: true),
                                                 response: response, request: request) }

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
          printer.generate.should eq(output[0..-2])
        end
      end
    end

    context "non-json response" do
      let(:response) { "Ender Wiggin" }

      before(:each) { response.stubs(:code).returns(200) }

      context "non-verbose" do
        let(:printer) { Resty::PrettyPrinter.new(stub(verbose?: false),
                                                 response: response, request: request) }

        it "returns output" do
          output = <<-eos.unindent
           > Response Code: 200
           Ender Wiggin
          eos

          # multi-line text adds an extra \n, so let's ignore it
          printer.generate.should eq(output[0..-2])
        end
      end

      context "verbose" do
        let(:printer) { Resty::PrettyPrinter.new(stub(verbose?: true),
                                                 response: response, request: request) }

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
           Ender Wiggin
          eos

          # multi-line text adds an extra \n, so let's ignore it
          printer.generate.should eq(output[0..-2])
        end
      end
    end
  end
end
