require 'digest/md5'

module Laravel
  LocalRepositories = File.expand_path(File.join(File.dirname(__FILE__), %w[ .. .. repositories ]))
  OfficialRepository = "http://github.com/laravel/laravel.git"

  # check if the given folder is a laravel source
  # we check this by looking for presence of 'artisan', 'laravel/', etc.
  def self.has_laravel?(directory)
    return false unless File.exists?    File.join( directory, "artisan" )
    return false unless File.directory? File.join( directory, "laravel" )
    true
  end

  # check if local repository exists for a given remote git source
  def self.local_repository_exists?(source)
    local_repository_path = Laravel::crypted_path(source)
    Laravel::has_laravel?(local_repository_path) ? local_repository_path : nil
  end

  # return the crypted folder name for a given remote repository
  def self.crypted_name(source)
    (Digest::MD5.new << source).to_s
  end

  # return the crypted folder path for a given remote repository
  def self.crypted_path(source)
    File.join(Laravel::LocalRepositories, Laravel::crypted_name(source))
  end

  # ask user for confirmation
  def self.yes?(message, color=nil)
    shell = Thor::Shell::Color.new
    shell.yes?(message, color)
  end

  # say something to the user.
  def self.say(status, message = "", log_status = true)
    shell = Thor::Shell::Color.new
    shell.say_status(status, message, log_status)
  end

  def self.say_info(message)
    self.say "Information", message, :cyan
  end

  def self.say_success(message)
    self.say "Success", message, :green
  end

  def self.say_failed(message)
    self.say "Failed!!", message, :yellow
  end

  def self.say_error(message)
    self.say "!!ERROR!!", message, :red
    exit
  end
end
