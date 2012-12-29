# laravel framework exists in a given directory
Given /^laravel (?:framework|application)( does not)? exists? in "(.*?)" directory$/ do |negate, dir|
  dir = expand_path(dir)
  FileUtils.rm_rf(dir)
  # easiest way to do this is to download github repository at this location
  `git clone -q http://github.com/laravel/laravel #{dir}` unless negate
end

# local cache exists for a given repository
Given /^local cache for "(.*?)" (does not )?exists?$/ do |repo, negate|
  app = create_test_app nil, repo
  FileUtils.rm_rf app.cache if negate or not app.has_cache?
  # easiest method to ensure local cache exists is to clone repo from github
  `git clone #{app.source} #{app.cache} &>/dev/null` unless app.has_cache?
end

# no applications have been created => local cache does not exist
Given /^(no )?applications? (?:has|have) been created using "(.*?)" as source$/ do |negate, repo|
  step "local cache for \"#{repo}\"#{negate ? " does not" : ""} exist"
end

# create an application
When /^.*create (?:an|this) application(?:| with above requirements)( in the current directory)?$/ do |current_dir|
  @source ||= "http://github.com/laravel/laravel"
  @app      = create_test_app current_dir, @source
  @config   = @config.chomp(",")
  @args     = "#{@args} --config=#{@config}" unless @config.empty?
  step "I run `laravel new #{@app.app_path} #{@args}`"
end

# make sure that the application is ready for development
Then /^(?:|this |the )application should be ready for development$/ do
  step "local cache should exist"
  step "application should be created"
  step "I should not fail while doing so"
end
# check if the local cache exists after we create an application
Then /^local cache should( not)? exist$/ do |negate|
  message = "local cache at #{@app.cache} to exist for source => #{@app.source}"
  unexpected?(@app.has_cache?, !negate, message)
end
# check if the application was created successfully
Then /^application should( not)? be created$/ do |negate|
  step "the stdout should contain \"Hurray!\"" unless negate
  message = "application to be created"
  unexpected?(@app.has_laravel?, !negate, message)
end

# start creating an application and initialize @args, @config parameters
Given /.*want to create (?:an|the|a new) application( forcefully)?$/ do |force|
  @config = ""
  @args = force ? "--force" : ""
end

# specify a source repository
Given /^I want to use( local cache for)? "(.*?)" as source$/ do |use_cache, source|
  @source = source
  @args = "#{@args} --source=#{source}"
end

# specify whether we want to udpate permissions or not
Given /^I( do not)? want to update file permissions for storage$/ do |negate|
  @args = "#{@args} #{negate ? "--no-perms" : "--perms"}"
end
# check if the permissions were updated
Then /^file permissions on storage should( not)? be updated$/ do |negate|
  step "the stdout should contain \"Updated permissions\"" unless negate

  storage_dir = File.join(@app.app_path, "storage")
  # capture the last integer for the permissions mode
  world_bit = sprintf("%o", File.stat(storage_dir).mode).to_s[-1,1].to_i
  # file is world-writable if last integer is 2, 3, 6, or 7
  actual = [2,3,6,7].include?(world_bit)

  expected = !negate
  message = "#{storage_dir} to be world-writable"
  unexpected?(actual, expected, message)
end


