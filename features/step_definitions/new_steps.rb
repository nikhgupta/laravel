Given /^laravel (?:framework|application)( does not)? exists? in "(.*?)" directory$/ do |negate, dir|
  dir = File.expand_path(dir, Laravel::AppTests::TestDirectory)
  FileUtils.rm_rf(dir)
  # easiest way to do this is to download github repository at this location
  `git clone -q http://github.com/laravel/laravel #{dir}` unless negate
end

Given /^local cache for "(.*?)" (does not )?exists?$/ do |repo, negate|
  tester = Laravel::AppTests.new(".", repo)
  if negate
    FileUtils.rm_rf tester.app.cache
  elsif not tester.app.has_cache?
    # easiest method to ensure local cache exists is to clone repo from github
    FileUtils.rm_rf tester.app.cache
    `git clone #{tester.app.source} #{tester.app.cache} &>/dev/null`
  end
end

Given /^(no )?applications? (?:has|have) been created using "(.*?)" as source$/ do |negate, repo|
  step "local cache for \"#{repo}\" #{negate ? "does not exist" : "exists"}"
end



When /^.*create (?:an|this) application(?:| with above requirements)( in the current directory)?$/ do |current_dir|
  dir = current_dir ? "." : "my_app"
  @source   ||= "http://github.com/laravel/laravel"
  @app_tester = Laravel::AppTests.new(dir, @source)
  @app        = @app_tester.app
  @app_path   = @app_tester.app_path
  @cache      = @app_tester.app.cache

  step "I run `laravel new #{dir} #{@args}`"
end


Then /^(?:|this |the )application should be ready for development$/ do
  step "local cache should exist"
  step "application should be created"
end
Then /^local cache should( not)? exist$/ do |negate|
  @app_tester.raise_error?(@app.has_cache?, negate)
end
Then /^application should( not)? be created$/ do |negate|
  step "the stdout should contain \"Hurray!\"" unless negate
  @app_tester.raise_error?(@app.has_laravel?, negate)
end
