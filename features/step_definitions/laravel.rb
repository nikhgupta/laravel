# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end

#### GIVEN ####
# local cache exists
Given /^local cache( does not)? exists? for "(.*?)" repository$/ do |negation, repo|
  repo_url  = get_test_repo_url(repo)
  repo_path = get_test_repo_path(repo, repo_url)
  if negation
    FileUtils.rm_rf repo_path
  else
    # easiest method to ensure local cache exists is to clone repo from github
    unless Laravel::has_laravel?(repo_path)
      FileUtils.rm_rf repo_path
      `git clone #{repo_url} #{repo_path} &>/dev/null`
    end
  end
end

# laravel exists in directory
Given /^laravel application exists in "(.*?)" directory$/ do |dir|
  dir = get_relative_path_to_test_directory(dir)
  Laravel::Create::source(dir, :force => true, :quiet => true) unless Laravel::has_laravel?(dir)
end

# laravel has been downloaded in directory
Given /^laravel source has already been downloaded in "(.*?)" directory$/ do |dir|
  # creating laravel in directory is virtually same as it being downloaded there
  step "laravel application exists in \"#{dir}\" directory"
end

#### THEN ####
# check if we have a running Laravel instance using 'Official' repository
Then /^laravel application should be ready to use in "(.*?)" directory$/ do |dir|
  step "local cache for \"official\" repository should exist"
  step "the stdout should contain \"Hurray!\""
  step "laravel application must exist in \"#{dir}\" directory"
  step "permissions should be updated on \"#{dir}/storage\" directory"
end

# check if we have a running Laravel instance using 'non-official' repository
Then /^laravel application should be ready to use in "(.*?)" directory using "(.*?)" repository$/ do |dir, repo|
  step "local cache for \"#{repo}\" repository should exist"
  step "the stdout should contain \"Hurray!\""
  step "laravel application must exist in \"#{dir}\" directory"
  step "permissions should be updated on \"#{dir}/storage\" directory"
end

# check if local cache exists
Then /^local cache for "(.*?)" repository should( not)? exist$/ do |repo, negation|
  repo_path = get_test_repo_path(repo)
  raise_error_based_on_condition(Laravel::has_laravel?(repo_path), negation)
end

# check if laravel application exists in the given directory
Then /^laravel application must( not)? exist in "(.*?)" directory$/ do |negation, dir|
  dir = get_relative_path_to_test_directory(dir)
  raise_error_based_on_condition(Laravel::has_laravel?(dir), negation)
end

# check if valid permissions were set on the "storage/" directory
Then /^permissions should( not)? be updated on "(.*?)" directory$/ do |negation, dir|
  dir = get_relative_path_to_test_directory(dir)
  world_bit = sprintf("%o", File.stat(dir).mode).to_s[-1].to_i
  is_world_writable = [2,3,6,7].include?(world_bit)
  raise_error_based_on_condition(is_world_writable, negation)
end

# check if application index was set
Then /^application index must be set to "(.*?)" for "(.*?)" application$/ do |new_index, app_directory|
  check_config_file_for_string("'index' => '#{new_index}'", app_directory)
end

# check if application key was set
Then /^application key must(| not) be set for "(.*?)" application$/ do |negation, app_directory|
  key_regex = negation.empty? ? "[0-9a-f]{32}" : "YourSecretKeyGoesHere!"
  check_config_file_for_string("'key' => '#{key_regex}'", app_directory)
end
