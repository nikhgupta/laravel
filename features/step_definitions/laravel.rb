# existance of local cache
Given /^local cache exists for "(.*?)" repository$/ do |repo|
  repo_url  = get_test_repo_url(repo)
  repo_path = get_test_repo_path(repo, repo_url)
  # easiest method to ensure local cache exists is to clone repo from github
  unless Laravel::has_laravel?(repo_path)
    FileUtils.rm_rf repo_path
    `git clone #{repo_url} #{repo_path} &>/dev/null`
  end
end

Given /^local cache does not exist for "(.*?)" repository$/ do |repo|
  repo_path = get_test_repo_path(repo)
  FileUtils.rm_rf repo_path
end

Then /^local cache for "(.*?)" repository should exist$/ do |repo|
  repo_path = get_test_repo_path(repo)
  raise RSpec::Expectations::ExpectationNotMetError unless Laravel::has_laravel?(repo_path)
end

# download related
Given /^laravel source has already been downloaded in "(.*?)" directory$/ do |dir|
  default_repo = get_test_repo_path("official")
  dir = get_relative_path_to_test_directory(dir)
  # creating new default app is virtually same as downloading the source code
  Laravel::Create::source(dir, :force => true, :quiet => true) unless Laravel::has_laravel?(dir)
end

Given /^laravel application exists in "(.*?)" directory$/ do |dir|
  dir = get_relative_path_to_test_directory(dir)
  Laravel::Create::source(dir) unless Laravel::has_laravel?(dir)
end

# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end
