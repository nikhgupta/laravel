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

  # check if this is the first installation from this gem

  # check if local repository exists for a given remote git source
  def self.local_repository_exists?(source)
    local_repository_path = Laravel::crypted_path(source)
    if Laravel::has_laravel? local_repository_path
      local_repository_path
    else
      nil
    end
  end

  # return the crypted folder name for a given remote repository
  def self.crypted_name(source)
    (Digest::MD5.new << source).to_s
  end

  # return the crypted folder path for a given remote repository
  def self.crypted_path(source)
    File.join(Laravel::LocalRepositories, Laravel::crypted_name(source))
  end
end
