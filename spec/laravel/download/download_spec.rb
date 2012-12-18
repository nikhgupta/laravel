require 'spec_helper'

describe Laravel::Download do

  before(:each) { Laravel::Tests::cleanup }
  after(:each)  { Laravel::Tests::cleanup }

  it "should download source from a manually specified laravel repository" do
    # preparations
    options = { :remote => "https://github.com/laravel/pastes.git" }
    Laravel::Tests::cleanup options[:remote]

    # actions
    print "  downloading git repository.. this may take a while.."
    app_path = Laravel::Tests::app_downloads_nicely? options

    # expectations
    app_path.should_not be_nil
    Laravel::local_repository_exists?(options[:remote])
    Laravel::Tests::download_was_performed?(app_path)
  end

  it "should not download source from a non-laravel app" do
    # preparations
    options = { :remote => "http://github.com/nikhgupta/snipmate-snippets.git" }

    # actions
    print "  downloading git repository.. this may take a while.."
    app_path = Laravel::Tests::app_downloads_nicely? options

    # expectations
    app_path.should be_nil
    !Laravel::local_repository_exists?(options[:remote])
    !Laravel::Tests::download_was_performed?(app_path)
  end

  it "should download source from the official repository" do
    # preparations
    Laravel::Tests::cleanup Laravel::OfficialRepository

    # actions
    print "  downloading git repository.. this may take a while.."
    app_path = Laravel::Tests::app_downloads_nicely?

    # expectations
    app_path.should_not be_nil
    Laravel::local_repository_exists?(Laravel::OfficialRepository)
    Laravel::Tests::download_was_performed?(app_path)
  end

  it "should copy source from local repository cache" do
    # preparations
    # should only be run with the previous test
    # act as cached repo
    options = { :remote => Laravel::crypted_path(Laravel::OfficialRepository) }

    # actions
    app_path = Laravel::Tests::app_downloads_nicely?

    # expectations
    app_path.should_not be_nil
    Laravel::Tests::download_was_performed?(app_path)
  end

  it "should copy source from a manually specified directory" do
    # preparations
    # acts as local directory
    options = { :local => Laravel::crypted_path(Laravel::OfficialRepository) }

    # actions
    app_path = Laravel::Tests::app_downloads_nicely? options

    # expectations
    app_path.should_not be_nil
    Laravel::Tests::download_was_performed?(app_path)
  end

end
