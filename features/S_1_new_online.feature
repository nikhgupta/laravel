Feature: Create a new application based on Laravel framework for PHP when online
  In order to develop awesome web application
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to setup Laravel framework using online sources

  Scenario: create Laravel application with default settings
    Given no application has been created using "http://github.com/laravel/laravel" as source
    And   I want to create a new application
    When  I create this application
    Then  application should be ready for development

  Scenario: create Laravel application in the current directory
    Given I want to create a new application forcefully
    When  I create this application
    Then  application should be ready for development
    Given I, again, want to create a new application
    When  I, now, create this application
    Then  I should get an error

  Scenario: create Laravel application using source from a non-official repo
    Given no application has been created using "http://github.com/laravel/pastes" as source
    And   I want to create a new application
    And   I want to use "http://github.com/laravel/pastes" as source
    When  I create an application with above requirements
    Then  application should be ready for development

  Scenario: create Laravel application using non-laravel repository
    Given I want to create a new application
    And   I want to use "http://github.com/github/gitignore" as source
    When  I create an application with above requirements
    Then  local cache should not exist
    And   I should get an error
    And   the stdout should contain "corrupt"
    And   application should not be created
