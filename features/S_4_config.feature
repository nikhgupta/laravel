Feature: Configure an existing Laravel application
  In order to customize the application to my needs
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to configure this application

  Background: An application based on Laravel framework exists
    Given I want to create a new application
    When  I create this application
    Then  the application should be ready for development

  Scenario: update Application's URL
    When  I run `laravel config update url "http://laravel.com"` inside this application
    Then  the application "url" should be updated to "http://laravel.com"
    
  Scenario: update Application's asset URL
    When  I run `laravel config update asset_url "http://laravel.com"` inside this application
    Then  "asset_url" should be updated to "http://laravel.com"

  Scenario: update Application Index
    When  I run `laravel config update index "home.php"` inside this application
    Then  the application "index" should be updated to "home.php"

  Scenario: generate a new key for a Laravel application
    When  I run `laravel config update key` inside this application
    Then  an application key should be generated

  Scenario: set a fixed key for a Laravel application
    When  I run `laravel config update key my_special_key` inside this application
    Then  the application "key" should be updated to "my_special_key"

  Scenario: turn on/off the profiler for the application
    When  I run `laravel config update profiler active` inside this application
    Then  the "profiler" should be turned on

  Scenario: turn on/off the ssl
    When  I run `laravel config update ssl enabled` inside this application
    Then  the "ssl" should be turned on

  Scenario: update Application's language
    When  I run `laravel config update language hi` inside this application
    Then  the "language" should be updated to "hi"

  Scenario: update Application's encoding
    When  I run `laravel config update encoding "US-ASCII"` inside this application
    Then  the "encoding" should be updated to "US-ASCII"

  Scenario: update Application's timezone
    When  I run `laravel config update timezone "UTC+5:30"` inside this application
    Then  the "timezone" should be updated to "UTC+5:30"

  Scenario: update supported languages
    When  I run `laravel config update languages "array('hi', 'en')"` inside this application
    Then  I should fail while doing so

  Scenario: configuration that are boolean can take multiple arguments
    # on/off
    When  I run `laravel config update profiler on` inside this application
    Then  the "profiler" should be turned on
    When  I run `laravel config update ssl off` inside this application
    Then  the "ssl" should be turned off
    # yes/no
    When  I run `laravel config update ssl yes` inside this application
    Then  the "ssl" should be turned on
    When  I run `laravel config update profiler no` inside this application
    Then  the "profiler" should be turned off
    # active/inactive
    When  I run `laravel config update ssl active` inside this application
    Then  the "ssl" should be turned on
    When  I run `laravel config update profiler inactive` inside this application
    Then  the "profiler" should be turned off
    # enabled/disabled
    When  I run `laravel config update profiler enabled` inside this application
    Then  the "profiler" should be turned on
    When  I run `laravel config update ssl disabled` inside this application
    Then  the "ssl" should be turned off

  Scenario: can read configuration settings
    When  I run `laravel config update url "http://laravel.com"` inside this application
    And   I run `laravel config get url` inside this application
    Then  I should see "Configuration: url => 'http://laravel.com'"
    When  I run `laravel config update profiler false` inside this application
    And   I run `laravel config get profiler` inside this application
    Then  I should see "Configuration: profiler => false"
