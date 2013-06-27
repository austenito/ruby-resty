require 'spec_helper'

describe Resty::Commands::Delegator do
  let(:cli_options) { stub(verbose?: false) }
  let(:input) { "exit" }
  let(:delegator) { Resty::Commands::Delegator.new(cli_options, input) }

  before(:each) do
    delegator.stubs(:files).returns(["Exit"])
  end

  context "#find_command" do
    let(:command) { stub }

    before(:each) do
      Resty::Commands::Exit.stubs(:new).returns(command)
    end

    context "valid command" do
      before(:each) do 
        command.stubs(match?: true)
        @command = delegator.find_command
      end

      it "returns true" do
        expect(@command).not_to be_nil
      end

      it "invokes new" do
        Resty::Commands::Exit.should have_received(:new).with(cli_options, input)
      end

      it "sets command" do
        expect(delegator.command).to eq(command)
      end
    end

    context "invalid command" do
      before(:each) do 
        command.stubs(match?: false)
        @command= delegator.find_command
      end

      it "returns false" do
        Resty::Commands::Exit.stubs(:new).returns(stub(match?: false))
        expect(@command).to be_false
      end

      it "invokes new" do
        Resty::Commands::Exit.should have_received(:new).with(cli_options, input)
      end

      it "doesn't set command" do
        expect(delegator.command).to be_nil
      end
    end
  end

  context "#execute" do
    let(:command) { stub(execute: "") }

    context "valid command" do
      it "executes command" do
        delegator.stubs(:command).returns(command)
        delegator.execute
        command.should have_received(:execute)
      end

    end

    context "invalid command" do
      it "doesn't execute" do
        delegator.execute
      end
    end
  end
end
