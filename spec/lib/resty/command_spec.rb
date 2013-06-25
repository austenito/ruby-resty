require 'spec_helper'

describe Resty::Command do
  describe ".command?" do
    it "returns true" do
      Resty::Command::COMMANDS.each do |command|
        expect(Resty::Command.new(command).command?).to be_true
      end
    end

    it "returns false" do
      expect(Resty::Command.new("nyan cat").command?).to be_false
    end
  end

  describe "#exit" do
    it "raises interrupt" do
      command = Resty::Command.new("exit")
      expect{command.execute}.to raise_error(Interrupt)
    end
  end
end
