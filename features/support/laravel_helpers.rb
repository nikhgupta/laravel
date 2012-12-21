module LaravelHelpers
  TestDirectory = File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. tmp aruba]))

  # get the relative path of a directory relative to the temporary path aruba creates
  def get_relative_path_to_test_directory(dir, relative_to = nil)
    relative_to = TestDirectory unless relative_to
    File.expand_path(dir, relative_to)
  end

  # get the url to the repository by its name
  def get_test_repo_url(repo = nil)
    case repo
    when nil, "official", "default" then Laravel::OfficialRepository
    when "pastes"  then "http://github.com/laravel/pastes"
    when "non_laravel" then "http://github.com/github/gitignore"
    else repo
    end
  end

  # get the full path to the repository by its name
  def get_test_repo_path(repo = nil, repo_url = nil)
    repo_url = get_test_repo_url(repo) unless repo_url
    Laravel::crypted_path(repo_url)
  end

  # checks if the configuration file contains a particular string
  def check_config_file_for_string(search, dir)
    dir = get_relative_path_to_test_directory(dir)
    config_file = File.join(dir, %w[ application config application.php ])
    raise RSpec::Expectations::ExpectationNotMetError unless File.readlines(config_file).grep(/#{search}/).any?
  end

  # raises an error based on a condition and negation
  # if negation is not supplied, simply raises an error if condition is not true
  def raise_error_based_on_condition(condition, negate = nil)
    raise RSpec::Expectations::ExpectationNotMetError if condition == !negate.nil?
  end
end

World(LaravelHelpers)
