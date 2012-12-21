module LaravelHelpers
  TestDirectory = File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. tmp aruba]))

  def get_relative_path_to_test_directory(dir, relative_to = nil)
    relative_to = TestDirectory unless relative_to
    File.expand_path(dir, relative_to)
  end

  def get_test_repo_url(repo = nil)
    case repo
    when nil, "official", "default" then Laravel::OfficialRepository
    when "pastes"  then "http://github.com/laravel/pastes"
    when "non_laravel" then "http://github.com/github/gitignore"
    else repo
    end
  end

  def get_test_repo_path(repo = nil, repo_url = nil)
    repo_url = get_test_repo_url(repo) unless repo_url
    Laravel::crypted_path(repo_url)
  end

  def check_config_file_for_string(search, dir)
    dir = get_relative_path_to_test_directory(dir)
    config_file = File.join(dir, %w[ application config application.php ])
    raise RSpec::Expectations::ExpectationNotMetError unless File.readlines(config_file).grep(/#{search}/).any?
  end
end

World(LaravelHelpers)
