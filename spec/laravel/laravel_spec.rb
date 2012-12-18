require 'spec_helper'

describe Laravel do
  it "should have a version" do
    Laravel::VERSION.should_not be_nil
  end

  context "when creating a new application" do

    before(:each) { Laravel::Tests::cleanup }
    after(:each)  { Laravel::Tests::cleanup }

    it "should run with default options" do
      # actions
      print '    downloading git repository.. this may take a while..'
      app_path = Laravel::Tests::app_downloads_nicely?

      # expectations
      app_path.should_not be_nil
      Laravel::Tests::app_was_created? app_path
    end
  end
end

