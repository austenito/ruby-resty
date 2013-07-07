require 'spec_helper'

describe "method_command", :vcr do
  let(:cli_options) { Resty::CliOptions.new(host: "localhost:4567", username: "nyan", 
                                            password: "cat") }

  context "GET" do
    before(:each) do
      @result = pry_eval(cli_options, "get /api/nyan")
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
      @result = pry_eval(cli_options, "delete /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end
  end

  context "HEAD" do
    before(:each) do
      @result = pry_eval(cli_options, "head /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end
  end

  context "OPTIONS" do
    before(:each) do
      @result = pry_eval(cli_options, "options /api/nyan")
    end

    it "returns 200" do
      @result.response.code.should eq(200)
    end
  end

  context "POST" do
    before(:each) do
      @result = pry_eval(cli_options, "post /api/nyan {nyan: 'cat'}")
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
      @result = pry_eval(cli_options, "put /api/nyan {nyan: 'cat'}")
    end

    it "returns 204" do
      @result.response.code.should eq(204)
    end
  end

  context "PATCH" do
    before(:each) do
      @result = pry_eval(cli_options, "patch /api/nyan {nyan: 'cat'}")
    end

    it "returns 204" do
      @result.response.code.should eq(200)
    end
  end
end
