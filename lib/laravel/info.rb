module Laravel
  INFO = '''
  Create a new Laravel application

    # with default settings
    # fetches source from http://github.com/laravel/laravel.git
    laravel new my_app

    # force a clean install on existing directory
    laravel new my_app --force

    # using an existing (already downloaded) source
    laravel new my_app --local=/usr/src/laravel

    # using a remote repository
    laravel new my_app --remote="http://github.com/user/my_laravel_fork"
  '''
end
