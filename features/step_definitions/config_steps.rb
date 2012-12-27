Then /^configuration: "(.*?)" should be updated to "(.*?)"$/ do |config, value|
  value = '.*' if value == "__something__"
  @app_tester.validate_configuration("'#{config}' => '#{value}'")
  step "the stdout should contain \"Updated configuration: #{config}\""
end



Given /^I( do not)? want to generate a new key$/ do |negate|
  @args = "#{@args} #{negate ? "--no-key" : "--key"}"
end
When /^(?:|I |we )generate a new key(?:| for this application)$/ do
  step "I run `laravel config key --app=#{@app_path}`"
end
Then /^a new application key should be generated$/ do
  step "configuration: \"key\" should be updated to \"__something__\""
end



Given /^I want to use "(.*?)" as application index$/ do |index|
  @args = "#{@args} --index=#{index}"
end
When /^.*udpate application index to "(.*?)"$/ do |index|
  step "I run `laravel config index #{index} --app=#{@app_path}`"
end
Then /^the application index should be updated to "(.*?)"$/ do |index|
  step "configuration: \"index\" should be updated to \"#{index}\""
end

