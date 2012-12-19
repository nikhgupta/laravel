module Laravel
  INFO = '''
  Create a new Laravel application
  ================================
    laravel new my_app
      # use default settings
      # fetches source from http://github.com/laravel/laravel.git
    laravel new my_app --force
      # force a clean install on existing directory
    laravel new my_app --remote="http://github.com/user/my_laravel_fork"
      # use an existing (already downloaded) source
      # use a remote repository
    laravel new my_app --index=home.php
      # use default settings and update Application Index

  Update Application Index on existing Laravel applications
  =========================================================
    laravel update_index "home.php"
      # in the current directory
    laravel update_index "" --app=./laravel
      # for application in the specified directory
  '''
end
