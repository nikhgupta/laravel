module Laravel
  class Manage
    # modify the Application Index for application
    #
    # * *Args*    :
    #   - +new_index+ -> the new Application Index
    #   - +app_directory+ -> the directory of the Laravel app, defaults to current working directory
    #
    def self.update_index(new_index, app_directory = nil)
      if change_configuration(/'index' => '.*'/, "'index' => '#{new_index}'", app_directory)
        Laravel::say_success "Changed Application Index."
      else
        Laravel::say_failed "Could not change Application Index!"
      end
    end

    # generates a new key for the application
    #
    # * *Args*    :
    #   - +app_directory+ -> the directory of the Laravel app, defaults to current working directory
    #
    def self.generate_key(app_directory = nil)
      # 32 char long md5-ed hash
      new_key = (0...32).map{ ('a'..'z').to_a[rand(26)] }.join
      new_key = Laravel::crypted_name(new_key)

      # show an appropriate message to the user.
      if change_configuration(/'key' => '.*'/, "'key' => '#{new_key}'", app_directory)
        Laravel::say_success "Generated a new key."
      else
        Laravel::say_failed "Could not generate a new key!"
      end
    end

    # download the Laravel Generator by Jeffrey Way
    #
    # * *Args*    :
    #   - +app_directory+ -> the directory of the Laravel app, defaults to current working directory
    #
    def self.get_generator(app_directory = nil)
      # default to current working directory if path is not specified
      app_directory ||= Dir.pwd

      # get the path to the tasks folder
      tasks_directory = File.expand_path(File.join(app_directory, %w[ application tasks ]))

      # download the Laravel Generator
      generator_url  = "https://raw.github.com/JeffreyWay/Laravel-Generator/master/generate.php"
      generator_file = File.join(tasks_directory, "generate.php")
      success = system("curl -s #{generator_url} > #{generator_file}")
      if success
        Laravel::say_success "Downloaded Laravel Generator by Jeffrey Way"
      else
        Laravel::say_failed "Could not download Laravel Generator"
      end
    end

    private

    def self.change_configuration(match, replace, app_directory = nil)
      # default to current working directory if path is not specified
      app_directory ||= Dir.pwd

      # try to change configuration only if this is a Laravel application
      if Laravel::has_laravel? app_directory
        # file path to the configuration file
        config_file = %w[ application config application.php ]
        config_file = File.expand_path(File.join(app_directory, config_file))

        # perform substitution
        text = File.read config_file
        text = text.gsub(match, replace)
        File.open(config_file, "w") {|file| file.puts text}

        # check to ensure we were able to update configuration
        File.readlines(config_file).grep(/#{replace}/).any?
      else
        Laravel::say_error "Is this a valid Laravel application?"
      end
    end

  end
end
