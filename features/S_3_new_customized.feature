Feature: Create a new application with maximum customizations
  In order to develop awesome web application
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to setup a new application with maximum customizations

  Scenario: create Laravel application with maximum customizations
    Given no application has been created using "http://github.com/laravel/laravel" as source
    And   I want to create an application forcefully
    And   I want to use "http://github.com/laravel/laravel" as source
    And   I want to generate a new key
    And   I want to use "home.php" as application "index"
    And   I want to "enable" the "profiler"
    And   I want to "disable" the "ssl"
    And   I want to use "hi" as the "language"
    And   I want to use "http://pastes.laravel.com" as the application "url"
    When  I create an application with above requirements
    Then  application should be ready for development
    And   a new application key should be generated
    And   the application "index" should be updated to "home.php"
    And   the application "url" should be updated to "http://pastes.laravel.com"
    And   the "ssl" should be turned off
    And   the "profiler" should be turned on
    And   the "language" should be updated to "hi"

  Scenario: CLI UI
    Given applications have been created using "http://github.com/laravel/laravel" as source
    When  I run `laravel new my_app --force --config=index:'',key --source=http://github.com/laravel/laravel`
    Then  I should not fail while doing so
    And   I should see "forcefully"
    And   I should see "exists in local cache"
    And   I should see "Updating local cache"
    And   I should see "Cloned"
    And   I should see "Updated permissions"
    And   I should see "Updated configuration: index => __empty_string"
    And   I should see "Updated configuration: key"
    And   I should see "Hurray!"
