Then /^application index must be set to "(.*?)" for "(.*?)" application$/ do |new_index, app_directory|
  check_config_file_for_string("'index' => '#{new_index}'", app_directory)
end

# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end
