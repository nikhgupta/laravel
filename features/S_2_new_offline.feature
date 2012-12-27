Feature: Create a new application based on Laravel framework for PHP when offline
  In order to develop awesome web application
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to setup Laravel framework when not online

  Background: we have created some applications using this gem in the past
    Given applications have been created using "http://github.com/laravel/laravel" as source
    And   applications have been created using "http://github.com/laravel/pastes" as source

  Scenario: create Laravel application using repository from local cache
    Given I want to create a new application
    And   I want to use "http://github.com/laravel/laravel" as source
    When  I create an application with above requirements
    Then  application should be ready for development

  Scenario: create Laravel application using source from a directory
    # Given laravel framework exists in "./laravel" directory
    # And   I want to create a new application
    # And   I want to use "./laravel/" as source
    #
    # following is the encrypted path to local cache of default repo - makes test go faster
    Given I want to create a new application
    And   I want to use "~/.laravel/repos/d07cf9818b8fb1e073f23901b58505f6" as source
    When  I create an application with above requirements
    Then  application should be ready for development

  Scenario: create Laravel application but do not update permissions on storage/ directory
    Given I want to create a new application
    And   I do not want to update file permissions for storage
    When  I create an application with above requirements
    Then  application should be created
    But   file permissions on storage should not be updated
