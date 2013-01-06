module Laravel
  class CLI < Thor
    # This task creates a new application based on Laravel framework.  By
    # default, it simply copies a Laravel source to the path specified as the
    # argument. However, this method is heavily customizable and allows us to
    # create a ready to use Laravel application by handling tasks such as
    # updating the Application Index, generating a new key, updating
    # permissions on the storage/ directory, and even creating migration tables
    # for us in one go.
    #
    # ==== Options
    # +source+ :: [STRING] Specifies the source repository for downloading Laravel. This can
    #               either be an absolute/relative path from the current directory,
    #               or a URL to a git based repository we have access to. This can be
    #               very handy since it allows us to create new application based on a
    #               fork of the Laravel framework that we may have been working on.
    #               Furthermore, since we cache these source URLs, it speeds up future
    #               app creations using this method.
    # +perms+    :: [BOOLEAN] By default, it updates the permissions on the storage/ directory
    #               The permissions update can be skipped, by passing a '--no-perms' parameter.
    # +force+    :: [BOOLEAN] If we can not create an application at the specified path since it
    #               already exists or is not empty, passing this parameter will force us to create
    #               a new application, by first removing all the files inside the specified path.
    # +config+   :: [STRING] A comma-separated list of `key-value` pairs - read docs for more information
    # +generator+:: [BOOLEAN] If provided, this downloads the Laravel Generator by Jeffrey Way.
    #
    desc "new [MY_APP]", "create a new Laravel application"
    method_option :force,  :type => :boolean, :desc => "force overwrite"
    method_option :source, :type => :string,  :aliases => "-s", :banner => "GIT_REPO",
      :desc => "use this git repository - can be a directory or a URL"
    method_option :perms, :type => :boolean, :default => true,
      :desc => "default | update permissions on storage/ directory"
    method_option :config,  :type => :string,  :aliases => "-c",
      :desc => "configure the application using semi-colon separated list (read docs)"
    method_option :debug, :type => :boolean

    def new(app_name)
      begin
        Laravel::App.new(app_name, options).create
      rescue StandardError => e
        Laravel::handle_error e, options[:debug]
      end
    end

  end
end
