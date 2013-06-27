require 'spec_helper'

describe Resty::Commands::Exit do
  let(:cli_options) { stub(verbose?: false) }

  context "#valid?" do
    it "returns true" do
      expect(Resty::Commands::Exit.new(cli_options, "exit")).to be_true
      expect(Resty::Commands::Exit.new(cli_options, "EXIT")).to be_true
    end

    it "returns false" do
      expect(Resty::Commands::Exit.new(cli_options, "nyan").match?).to be_false
      expect(Resty::Commands::Exit.new(cli_options, nil).match?).to be_false
    end
  end

  context "#execute" do
    it "raises Interrupt" do
      command = Resty::Commands::Exit.new(cli_options, "")
      expect { command.execute }.to raise_error(Interrupt)
    end
  end
end
