require 'spec_helper'

describe Laravel::Download do

  it "should download source from a manually specified laravel repository" do
    # preparations
    app_name = 'test_12131'
    options = { :remote => "https://github.com/laravel/pastes.git" }
    Laravel::Tests::cleanup(app_name, options[:remote])

    # actions
    app_path = Laravel::Tests::app_downloads_nicely? app_name, options

    # expectations
    app_path.should_not be_nil
    Laravel::local_repository_exists?(options[:remote])
    Laravel::Tests::download_was_performed?(app_path)

    # cleanup
    Laravel::Tests::cleanup(app_name)
  end

  it "should copy source from a manually specified directory" do
    # preparations
    app_name = "test_21312"
    # acts as local directory
    options = { :local => Laravel::crypted_path(Laravel::OfficialRepository) }
    Laravel::Tests::cleanup(app_name)

    # actions
    app_path = Laravel::Tests::app_downloads_nicely? app_name, options

    # expectations
    app_path.should_not be_nil
    Laravel::Tests::download_was_performed?(app_path)

    # cleanup
    Laravel::Tests::cleanup(app_name)
  end

  it "should not download source from a non-laravel app" do
    # preparations
    app_name = "test_13212"
    options = { :remote => "http://github.com/nikhgupta/snipmate-snippets.git" }
    Laravel::Tests::cleanup(app_name)

    # actions
    app_path = Laravel::Tests::app_downloads_nicely? app_name, options

    # expectations
    app_path.should be_nil
    !Laravel::local_repository_exists?(options[:remote])
    !Laravel::Tests::download_was_performed?(app_path)

    # cleanup
  end

  it "should download source from the official repository" do
    # preparations
    app_name = 'test_12312'
    Laravel::Tests::cleanup(app_name, Laravel::OfficialRepository)

    # actions
    app_path = Laravel::Tests::app_downloads_nicely? app_name

    # expectations
    app_path.should_not be_nil
    Laravel::local_repository_exists?(Laravel::OfficialRepository)
    Laravel::Tests::download_was_performed?(app_path)

    # cleanup
    Laravel::Tests::cleanup(app_name)
  end

  it "should copy source from local repository cache" do
    # preparations
    # should only be run with the previous test
    app_name = "test_31213"
    # act as cached repo
    options = { :remote => Laravel::crypted_path(Laravel::OfficialRepository) }
    Laravel::Tests::cleanup(app_name)

    # actions
    app_path = Laravel::Tests::app_downloads_nicely? app_name

    # expectations
    app_path.should_not be_nil
    Laravel::Tests::download_was_performed?(app_path)

    # cleanup
    Laravel::Tests::cleanup(app_name)
  end

end
