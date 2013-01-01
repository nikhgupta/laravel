module Laravel
  # various methods that help with the Cucumber Tests
  module TestHelpers
    TestDirectory = File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. tmp aruba]))

    # expand path to a directory relative to the test directory
    #
    # ==== Parameters
    # +dir+ :: path to the application directory
    #
    # ==== Return
    # +string+ :: absolute path to the application directory
    #
    def expand_path(dir = nil)
      dir ||= Dir.pwd
      File.expand_path(dir, TestDirectory)
    end

    # checks if the configuration file contains a particular string
    #
    # ==== Parameters
    # +search+ :: the search term/regex pattern to look for
    #
    # ==== Return
    # +boolean+:: true, if the search term was found in the configuration file.
    #
    def validate_configuration(config, value, config_file)
      match = File.read(config_file).match(/'#{config}' => (.*),/)
      expected = !match.nil?
      message = "configuration \"#{config}\" to be present in the configuration file."
      unexpected_unless expected, message

      # quote the value if it is not boolean
      value = "'#{value}'" unless ["true", "false"].include?(value)
      # config is valid if it matches the passed value or if its "__something__"
      expected = (value == "'__something__'") || (value == match[1])
      message = "configuration \"#{config}\" to be \"#{value}\" instead of \"#{match[1]}\""
      unexpected_unless expected, message
    end

    def create_test_app(dir = nil, repo = nil)
      dir     = dir ? "." : "my_app"
      dir     = expand_path(dir)
      options = { :force => true, :quiet => false, :perms => true, :source => repo }
      Laravel::App.new(dir, options)
    end

    # raises an error based on a condition and negation
    # if negation is not supplied, simply raises an error if condition is not true
    #
    # ==== Parameters
    # +actual+   :: a condition to check against - if +expected+ is not provided,
    #               raises an error if +actual+ is (or evaluates to) false
    # +expected+ :: negate the default behaviour
    def unexpected?(actual, expected, message = "")
      message ||= "#{expected} instead of #{actual}"
      message   = "#{expected ? "Expected" : "Did not expect"} #{message}"
      # actual and expected can either be boolean or string
      actual    = !actual.empty? if actual.is_a?(String) and not expected.is_a?(String)
      raise ExpectationNotMetError, message if actual != expected
    end

    def unexpected_if(actual, message = "")
      unexpected? actual, false, message
    end

    def unexpected_unless(actual, message = "")
      unexpected? actual, true, message
    end

  end
end

World(Laravel::TestHelpers)
