Given /.*want to create (?:an|the|a new) application( forcefully)?$/ do |force|
  @args = force ? "--force" : ""
end

Given /^I want to use( local cache for)? "(.*?)" as source$/ do |use_cache, source|
  @source = source
  @args = "#{@args} --source=#{source}"
end



Given /^I( do not)? want to update file permissions for storage$/ do |negate|
  @args = "#{@args} #{negate ? "--no-perms" : "--perms"}"
end
Then /^file permissions on storage should( not)? be updated$/ do |negate|
  step "the stdout should contain \"Updated permissions\"" unless negate
  world_bit = sprintf("%o", File.stat(@app_path).mode).to_s[-1,1].to_i
  is_world_writable = [2,3,6,7].include?(world_bit)
  @app_tester.raise_error?(is_world_writable, negate)
end
