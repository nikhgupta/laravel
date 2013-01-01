# failure?
Then /^I should( not)? fail (?:in|when|while|for) doing so$/ do |negate|
  step "the stdout should#{negate} contain \"Failed\""
  step "the stdout should not contain \"ERROR\"" if negate
end

# error?
Then /^I should( not)? (?:get|see) an error$/ do |negate|
  step "the stdout should#{negate} contain \"ERROR\""
end

# CLI output
Then /^I should see "(.*?)"$/ do |string|
  step "the stdout should contain \"#{string}\""
end

# S_0__release
# These tests are only run when we plan for releasing the gem, and hence,
# we are running the full test suite.
Given /^I want to make sure everything runs before releasing (?:|the |this )gem$/ do
  data_dir = File.expand_path(File.join(ENV['HOME'], ".laravel"))
  FileUtils.rm_rf data_dir
end

# remind me if I have not updated the README.md before a release
# I create 'feature' branches, which I then merge with 'develop' branch.
# Hence, README.md should be updated with details of the new feature.
Then /^the readme should( not)? be updated with new information$/ do |negate|
  last_tag = `git tag | tail -1`.strip
  actual   = `git diff #{last_tag}..HEAD -- README.md`.strip
  expected = !negate
  message  = "README.md to be updated with new information"
  unexpected? actual, expected, message
end

# remind me if I have not updated the version string before a release
Then /^the version should be updated$/ do
  current  = "v#{Laravel::VERSION}"
  all_tags = `git tag`.split("\n").map {|t| t.strip}
  exists   = all_tags.include? current
  message  = "laravel version to be #{current} for this release"
  unexpected_if exists, message
end

# make sure no local cache exists before we run the full test suite
Then /^the directory with laravel data should( not)? exist$/ do |negate|
  data_dir = File.expand_path(File.join(ENV['HOME'], ".laravel"))
  actual   = File.directory?(data_dir)
  expected = !negate
  message  = "#{data_dir} to exist"
  unexpected? actual, expected, message
end

# remind me if the working directory is not clean
Then /^the working directory should( not)? be dirty$/ do |negate|
  actual   = `git status --porcelain`.strip
  expected = !negate
  message  = "working directory to be dirty"
  unexpected? actual, expected, message
end

# I have a habit of making quick commits marked by 'snapped' or 'snapshot(|s|ing)'
# whenever I leave my desk for some personal work.
# This quickly reminds me if such commits are present in the commit history.
Then /^snapshotted git commits should( not)? exist$/ do |negate|
  snapped  = `git log develop.. | grep 'snapped'`.strip
  snapshot = `git log develop.. | grep 'snapshot'`.strip
  actual   = snapped || snapshot
  expected = !negate
  message  = "commit history to contain snapshots"
  unexpected? actual, expected, message
end
