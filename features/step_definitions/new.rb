# creation of applications
Then /^laravel application must be created inside "(.*?)" directory$/ do |dir|
  dir = get_relative_path_to_test_directory(dir)
  raise RSpec::Expectations::ExpectationNotMetError unless Laravel::has_laravel?(dir)
end

Then /^laravel application must not be created inside "(.*?)" directory$/ do |dir|
  dir = get_relative_path_to_test_directory(dir)
  raise RSpec::Expectations::ExpectationNotMetError if File.exists?(dir)
end

Then /^laravel application must be created inside current directory$/ do
  dir = get_relative_path_to_test_directory('.')
  raise RSpec::Expectations::ExpectationNotMetError unless Laravel::has_laravel?(dir)
end

Then /^local cache for "(.*?)" repository should not be created$/ do |repo|
  repo = get_test_repo_path(repo)
  raise RSpec::Expectations::ExpectationNotMetError if File.exists?(repo)
end

# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end
