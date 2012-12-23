# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end

#### GIVEN ####

# This test setups a given condition where the local cache may or may not exist
# for a given source repository. It does so by removing the cache directory, and
# then recreating it, if not negated, by downloading the repository from github.
#
Given /^local cache( does not)? exists? for "(.*?)" repository$/ do |negation, repo|
  @app_tester = Laravel::AppTests.new(nil, repo)

  if negation
    FileUtils.rm_rf @app_tester.app.cache
  elsif not @app_tester.app.has_cache?
    # easiest method to ensure local cache exists is to clone repo from github
    FileUtils.rm_rf @app_tester.app.cache
    `git clone #{@app_tester.app.source} #{@app_tester.app.cache} &>/dev/null`
  end
end

# This test setups a given condition where the Laravel application exists in a
# given directory. It does so by removing the directory if it exists and then,
# creating a new Laravel application there.
#
Given /^laravel application exists in "(.*?)" directory$/ do |dir|
  FileUtils.rm_rf(dir) if File.directory?(dir)
  @app_tester = Laravel::AppTests.new(dir)
  @app_tester.app.merge_options(:force => true, :quiet => true)
  @app_tester.app.create unless @app_tester.app.has_laravel?
end

# This test setups a given condition where the Laravel framework source has
# been download in a given directory, which is essentially the same as testing
# whether a Laravel application existing in a given directory.
#
Given /^laravel source has already been downloaded in "(.*?)" directory$/ do |dir|
  # creating laravel in directory is virtually same as it being downloaded there
  step "laravel application exists in \"#{dir}\" directory"
end

#### THEN ####

# This test checks whether the Laravel application we created is ready to use in
# a given directory, which is to say whether we can readily use Laravel after
# the command 'new' has been issued. This test assumes that the source repository
# is the official Laravel repository.
#
Then /^laravel application should be ready to use in "(.*?)" directory$/ do |dir|
  step "local cache for \"official\" repository should exist"
  step "the stdout should contain \"Hurray!\""
  step "laravel application must exist in \"#{dir}\" directory"
  step "permissions should be updated on \"#{dir}/storage\" directory"
end

# This test checks whether the Laravel application we created is ready to use
# in a given directory using a given source repository, which is to say whether
# we can readily use Laravel after the command 'new' has been issued.
#
Then /^laravel application should be ready to use in "(.*?)" directory using "(.*?)" repository$/ do |dir, repo|
  step "local cache for \"#{repo}\" repository should exist"
  step "the stdout should contain \"Hurray!\""
  step "laravel application must exist in \"#{dir}\" directory"
  step "permissions should be updated on \"#{dir}/storage\" directory"
end

# This test checks whether the local cache exists for a given repository. It
# does so by calling the 'has_cache?' method on the application.
#
Then /^local cache for "(.*?)" repository should( not)? exist$/ do |repo, negation|
  @app_tester = Laravel::AppTests.new(nil, repo)
  @app_tester.raise_error?(@app_tester.app.has_cache?, negation)
end

# This test checks if a Laravel application exists (or was created) in the given
# directory. It does so by calling the 'has_laravel?' method on the application.
#
Then /^laravel application must( not)? exist in "(.*?)" directory$/ do |negation, dir|
  @app_tester = Laravel::AppTests.new(dir)
  @app_tester.raise_error?(@app_tester.app.has_laravel?, negation)
end

# This test checks if valid permissions were set on the "storage/" directory
# This test checks if the valid permissions were set on the "storage/" directory
# of the application.
#
Then /^permissions should( not)? be updated on "(.*?)" directory$/ do |negation, dir|
  @app_tester = Laravel::AppTests.new(dir)
  step "the stdout should contain \"Updated permissions\"" unless negation
  world_bit = sprintf("%o", File.stat(@app_tester.app_dir).mode).to_s[-1,1].to_i
  is_world_writable = [2,3,6,7].include?(world_bit)
  @app_tester.raise_error?(is_world_writable, negation)
end

# This test checks if the given configuration setting has been updated to a given
# value for the specified application.
#
Then /^configuration: "(.*?)" must be updated to "(.*?)" for "(.*?)" application$/ do |config, value, app_dir|
  value = '.*' if value == "__something__"
  @app_tester = Laravel::AppTests.new(app_dir)
  @app_tester.validate_configuration("'#{config}' => '#{value}'")
  step "the stdout should contain \"Updated configuration: #{config}\""
end

# This test checks if the given resource has been installed in the specified
# application.
#
Then /^(.*?): "(.*?)" should be installed (?:as|in) "(.*?)" for "(.*?)" application$/ do |type, name, filename, app_dir|
  @app_tester = Laravel::AppTests.new(app_dir)
  filepath = @app_tester.app.tasks_file(filename) if type == "task"
  @app_tester.raise_error?(File.exists?(filepath))
  step "the stdout should contain \"Installed #{type}: #{name.capitalize}\""
end
