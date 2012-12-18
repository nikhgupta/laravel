# Laravel

A wrapper around Laravel framework for PHP.  
Currently, is only capable of downloading Laravel source from
a local directory, some git based (online/offline) repository
or from the official source on Github.  
Still in development.

[![Code
Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/nikhgupta/laravel)

## Installation

Add this line to your application's Gemfile:

    gem 'laravel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install laravel

## Usage

### Create a new Laravel application

Laravel gem has a caching mechanism in-built, which allows to keep a local
copy when you use the remote repositories for the first time. After this,
whenever you use the remote repository again, it will only update the local
repository (as opposed to a fresh git clone, which is considerably slow for
certain connections). This will, further, allow you to install Laravel
applications even when you are not connected to the Internet.

Since, you can specify which git repository to use to fetch the Laravel
source, you can create new Laravel application based on your own or someone
else's fork of Laravel, if required. And, yes! These repositories will be
cached!

    # with default settings (fetches source from http://github.com/laravel/laravel.git)
    laravel new my_app
    
    # force a clean install on existing directory
    laravel new my_app --force
    
    # using an existing (already downloaded) source
    laravel new my_app --local=/usr/src/laravel

    # using a remote repository
    laravel new my_app --remote="http://github.com/user/my_laravel_fork"
    
### Help

    laravel help

## Coming Soon..
    # create and customize a new Laravel application
    laravel new my_app --index=''           # set application index to blank
    laravel new my_app --[no-]key           # generate a new key
    laravel new my_app --database=db_my_app # create a database, defaults to app name
    laravel new my_app --[no-]generator     # download the Laravel Generator by Jeffrey Way
    laravel new my_app --bundles=sentry,bob # install the provided bundles

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
