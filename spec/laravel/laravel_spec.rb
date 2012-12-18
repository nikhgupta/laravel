require 'spec_helper'

describe Laravel do
  it "should have a version" do
    Laravel::VERSION.should_not be_nil
  end
end

