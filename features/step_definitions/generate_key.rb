Then /^application key must(| not) be set for "(.*?)" application$/ do |negation, app_directory|
  key_regex = negation.empty? ? "[0-9a-f]{32}" : "YourSecretKeyGoesHere!"
  check_config_file_for_string("'key' => '#{key_regex}'", app_directory)
end

# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end
