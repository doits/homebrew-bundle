# Brew Bundle

Bundler for non-Ruby dependencies from Homebrew

[![Code Climate](https://codeclimate.com/github/Homebrew/homebrew-bundle/badges/gpa.svg)](https://codeclimate.com/github/Homebrew/homebrew-bundle)
[![Coverage Status](https://coveralls.io/repos/Homebrew/homebrew-bundle/badge.svg)](https://coveralls.io/r/Homebrew/homebrew-bundle)
[![Build Status](https://travis-ci.org/Homebrew/homebrew-bundle.svg)](https://travis-ci.org/Homebrew/homebrew-bundle)

## Requirements

[Homebrew](https://github.com/Homebrew/brew) or [Linuxbrew](https://github.com/Linuxbrew/brew) are used for installing the dependencies.
Linuxbrew is a fork of Homebrew for Linux, while Homebrew only works on Mac OS X.
This tool is primarily developed for use with Homebrew on Mac OS X but should work with Linuxbrew on Linux, too.

[brew tap](https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/brew-tap.md) is new feature in Homebrew 0.9, adds more GitHub repos to the list of available formulae.

[Homebrew Cask](https://github.com/caskroom/homebrew-cask) is optional and used for installing Mac applications.

[mas-cli](https://github.com/argon/mas) is optional and used for installing Mac App Store applications.

## Install

You can install as a Homebrew tap:

    $ brew tap Homebrew/bundle

## Usage

Create a `Brewfile` in the root of your project:

    $ touch Brewfile

Then list your Homebrew based dependencies in your `Brewfile`:

```ruby
cask_args appdir: '/Applications'
tap 'caskroom/cask'
tap 'telemachus/brew', 'https://telemachus@bitbucket.org/telemachus/brew.git'
brew 'imagemagick'
brew 'mysql', restart_service: true, conflicts_with: ['homebrew/versions/mysql56']
brew 'emacs', args: ['with-cocoa', 'with-gnutls']
cask 'google-chrome'
cask 'java' unless system '/usr/libexec/java_home --failfast'
cask 'firefox', args: { appdir: '~/my-apps/Applications' }
mas '1Password', id: 443987910
```

You can then easily install all of the dependencies with one of the following commands:

    $ brew bundle

If a dependency is already installed and there is an update available it will be upgraded.

### Dump

You can create a `Brewfile` from all the existing Homebrew packages you have installed with:

    $ brew bundle dump

The `--force` option will allow an existing `Brewfile` to be overwritten as well.

### Cleanup

You can also use `Brewfile` as a whitelist. It's useful for maintainers/testers who regularly install lots of formulae. To uninstall all Homebrew formulae not listed in `Brewfile`:

    $ brew bundle cleanup

Unless the `--force` option is passed, formulae will be listed rather than actually uninstalled.

### Check

You can check there's anything to install/upgrade in the `Brewfile` by running:

    $ brew bundle check

This provides a successful exit code if everything is up-to-date so is useful for scripting.

### Exec

Runs an external command within Homebrew's [superenv](https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md#superenv-notes) build environment:

    $ brew bundle exec -- bundle install

This sanitized build environment ignores unrequested dependencies, which makes sure that things you didn't specify in your `Brewfile` won't get picked up by commands like `bundle install`, `npm install`, etc. It will also add compiler flags which will help find keg-only dependencies like `openssl`, `icu4c`, etc.

### Restarting services

You can choose whether `brew bundle` restarts a service every time it's run, or
only when the formula is installed or upgraded in your `Brewfile`:

```ruby
# Always restart myservice
brew 'myservice', restart_service: true

# Only restart when installing or upgrading myservice
brew 'myservice', restart_service: :changed
```

## Note

Homebrew does not support installing specific versions of a library, only the most recent one, so there is no good mechanism for storing installed versions in a .lock file.

If your software needs specific versions then perhaps you'll want to look at using [Vagrant](https://vagrantup.com/) to better match your development and production environments.

## Contributors

Over 10 different people have contributed to the project, you can see them all here: https://github.com/Homebrew/homebrew-bundle/graphs/contributors

## Development

Source hosted at [GitHub](https://github.com/Homebrew/homebrew-bundle).
Report Issues/Feature requests on [GitHub Issues](https://github.com/Homebrew/homebrew-bundle/issues).

Tests can be ran with `bundle && bundle exec rake spec`

### Note on Patches/Pull Requests

 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a future version unintentionally.
 * Add documentation if necessary.
 * Commit, do not change Rakefile or history.
 * Send a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2015 Homebrew maintainers and Andrew Nesbitt. See [LICENSE](https://github.com/Homebrew/homebrew-bundle/blob/master/LICENSE) for details.
