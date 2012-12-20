module Laravel
  class Manage
    # modify the Application Index for application
    #
    # * *Args*    :
    #   - +new_index+ -> the new Application Index
    #   - +app_directory+ -> the directory of the Laravel app, defaults to current working directory
    #
    def self.update_index(new_index, app_directory = '')
      # default to current working directory if path is not specified
      app_directory ||= Dir.pwd

      # try to change index only if this is a Laravel application
      if Laravel::has_laravel? app_directory
        # file path to the configuration file
        config_file = %w[ application config application.php ]
        config_file = File.expand_path(File.join(app_directory, config_file))

        # perform substitution
        text = File.read config_file
        text = text.gsub(/'index' => '.*'/, "'index' => '#{new_index}'")
        File.open(config_file, "w") {|file| file.puts text}

        # check to ensure we were able to update index
        check = File.readlines(config_file).grep(/'index' => '#{new_index}'/).any?

        # show an appropriate message to the user.
        if check
          Laravel::say_success "Changed Application Index."
        else
          Laravel::say_failed "Could not change Application Index!"
        end

      else
        Laravel::say_error "Is this a valid Laravel application?"
      end
    end

  end
end
