require "aruba/cucumber"
require "laravel"

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

After do
  FileUtils.rm_rf(File.join(%w[ tmp aruba my_app]))
  FileUtils.rm_rf(File.join(%w[ tmp aruba laravel]))
end
