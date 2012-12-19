Given /^laravel application exists in "(.*?)" directory$/ do |dir|
  dir = get_relative_path_to_test_directory(dir)
  Laravel::Create::source(dir) unless Laravel::has_laravel?(dir)
end

Then /^application index must be set to "(.*?)" for "(.*?)" application$/ do |new_index, dir|
  dir = get_relative_path_to_test_directory(dir)
  config_file = File.join(dir, %w[ application config application.php ])
  File.readlines(config_file).grep(/'index' => '#{new_index}'/).any?
end

# suppress any output from Thor based shell while testing
module Laravel
  def self.say(status, message = "", log_status = true)
  end
end
