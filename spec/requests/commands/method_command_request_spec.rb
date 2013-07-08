require 'spec_helper'

describe "method_command", :vcr do
  let(:options) { Resty::Options.new(host: "localhost:4567", username: "nyan", 
                                            password: "cat") }

  context "GET" do
    before(:each) do
      @result = pry_eval(options, "get /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end

    it "returns response" do
      JSON.parse(@result.response).should eq("nyan" => "cat")
    end
  end

  context "DELETE" do
    before(:each) do
      @result = pry_eval(options, "delete /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end
  end

  context "HEAD" do
    before(:each) do
      @result = pry_eval(options, "head /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end
  end

  context "OPTIONS" do
    before(:each) do
      @result = pry_eval(options, "options /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end
  end

  context "POST" do
    before(:each) do
      @result = pry_eval(options, "post /api/nyan {nyan: 'cat'}")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end

    it "returns created object" do
      JSON.parse(@result.response.body).should eq("nyan" => "cat")
    end
  end

  context "PUT" do
    before(:each) do
      @result = pry_eval(options, "put /api/nyan {nyan: 'cat'}")
    end

    it "returns 204" do
      @result.response.code.should eq(204)
    end
  end

  context "PATCH" do
    before(:each) do
      @result = pry_eval(options, "patch /api/nyan {nyan: 'cat'}")
    end

    it "returns 204" do
      @result.response.code.should eq(200)
    end
  end
end
