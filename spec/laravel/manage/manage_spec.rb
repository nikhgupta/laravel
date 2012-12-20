require 'spec_helper'

describe Laravel::Manage do

  before(:each) { Laravel::Tests::cleanup }
  after(:each)  { Laravel::Tests::cleanup }

  it "should update application index" do
    # actions
    print "  downloading git repository.. this may take a whole.."
    app_path = Laravel::Tests::app_downloads_nicely?
    Laravel::Manage::update_index "12312112321", app_path

    # expectations
    config_file = %w[ application config application.php ]
    config_file = File.expand_path(File.join(app_path, config_file))
    File.readlines(config_file).grep(/'index' => '12312112321'/).any?
  end
end
