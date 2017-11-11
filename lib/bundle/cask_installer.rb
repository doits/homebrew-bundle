# frozen_string_literal: true

module Bundle
  module CaskInstaller
    module_function

    def install(name, options = {})
      args = options.fetch(:args, {})

      if installed_casks.include? name
        if cask_up_to_date?(name)
          puts "Skipping install of #{name} cask. It is already installed." if ARGV.verbose?
          return :skipped
        else
          # without `--force` it will not overwrite the already existing .app
          args['force'] = true
          puts "Cask #{name} is outdated." if ARGV.verbose?
        end
      elsif ARGV.verbose?
        puts "Cask #{name} is not installed."
      end

      args = args.map do |k, v|
        if v.is_a?(TrueClass)
          "--#{k}"
        elsif v.is_a?(FalseClass)
          nil
        else
          "--#{k}=#{v}"
        end
      end.compact

      puts "Installing #{name} cask. It is not currently installed." if ARGV.verbose?

      return :failed unless Bundle.system "brew", "cask", "install", name, *args

      installed_casks << name
      :success
    end

    def installed_casks
      @installed_casks ||= Bundle::CaskDumper.casks
    end

    def self.cask_up_to_date?(name)
      # Determine it by looking at info outpu
      info_output = `brew cask info #{name}`

      # `brew cask info` outputs `Not installed` when a cask's is not
      # installed. So this is not up to date.
      return false if info_output.index('Not installed')

      # For an installed casks, it outputs the installed version number after
      # the cask name. For example:
      #
      # firefox: 48.0.1
      # https://www.mozilla.org/en-US/firefox/
      # /usr/local/Caskroom/firefox/47.0 (2 files, 589.4K)
      # /usr/local/Caskroom/firefox/48.0 (68B)
      # From: https://github.com/caskroom/homebrew-cask/blob/master/Casks/firefox.rb
      # ==> Name
      # Mozilla Firefox
      # ==> Artifacts
      # Firefox.app (app)
      #
      # We extract the version number (`48.0.1`) and compare it with the
      # installed path, because the version number is part of it. If the path
      # is not found, like in the case above, it means an old version was
      # installed. When the CLI output of `brew cask` changes, this has to be
      # updated, too.
      version_string = info_output.lines.first.chomp.sub(/^.*:./, '')
      %r{^/usr/local/.*/#{version_string} } =~ info_output
    end
  end
end
