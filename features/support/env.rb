require "aruba/cucumber"
require "laravel"

# After a scenario has been ran, deleted the files we may have created.
After do
  test_directory = Laravel::TestHelpers::TestDirectory
  FileUtils.rm_rf(File.join(test_directory, "my_app"))
  FileUtils.rm_rf(File.join(test_directory, "laravel"))
  FileUtils.rm_rf(File.join(test_directory, "current"))
end

Before do
  @aruba_timeout_seconds = 300
end

World(Laravel::Helpers)
