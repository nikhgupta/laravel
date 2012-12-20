require "aruba/cucumber"
require "laravel"

After do
  test_directory = File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. tmp aruba]))
  FileUtils.rm_rf(File.join(test_directory, "my_app"))
  FileUtils.rm_rf(File.join(test_directory, "laravel"))
  FileUtils.rm_rf(File.join(test_directory, "current"))
end

Before('@very_slow') do
  @aruba_timeout_seconds = 300
end

Before('@requires_repository_download') do
  @aruba_timeout_seconds = 300
end

Before('@may_require_repository_download') do
  @aruba_timeout_seconds = 300
end

Before('@slow') do
  @aruba_timeout_seconds = 60
end
