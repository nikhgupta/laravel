# specific to most configuration updates #

# specify the configuration settings we want to use when running the test
Given /^I want to (?:set|use|configure) "(.*?)" as(?:| the)(?:| application) "(.*?)"$/ do |value, setting|
  @config = "#{@config}#{setting}:#{value},"
end
Given /^I want to "(.*?)" (?:|the )"(.*?)"$/ do |switch, setting|
  switch = ["enable"].include?(switch)
  @config = "#{@config}#{setting}:#{switch ? "on" : "off"},"
end

# run a command in the application being tested
When /^I run `(.*?)` inside this application$/ do |command|
  step "I run `#{command} --app=#{@app.path}`"
end

# make sure that the configuration setting was updated correctly
Then /^(?:|the )(?:|application )"(.*?)" should be updated to "(.*?)"$/ do |setting, value|
  step "configuration: \"#{setting}\" should be updated to: \"#{value}\""
end
Then /^the "(.*?)" should be turned (on|off)$/ do |setting, value|
  step "configuration: \"#{setting}\" should be updated to: \"#{value == "on"}\""
end

# specify if we want to generate a new application key
Given /^I( do not)? want to generate a new key$/ do |negate|
  @config = "#{@config}#{negate ? "" : "key,"}"
end
# make sure that the application key was updated to something
Then /application key should be generated$/ do
  step "configuration: \"key\" should be updated to: \"__something__\""
end



# check configuration for a key => value pair
Then /^configuration: "(.*?)" should be updated to: "(.*?)"$/ do |config, value|
  validate_configuration(config, value, @app.config_file)
  step "the stdout should contain \"Updated configuration: #{config}\""
end

