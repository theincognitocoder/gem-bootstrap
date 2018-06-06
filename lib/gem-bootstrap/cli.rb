# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'netrc'
require 'uri'

module GemBootstrap
  # @api private
  class CLI

    MISSING_GH_USERNAME =
      'Unable to determine GitHub username, use --github-username option'

    GEM_NAME_NOT_AVAILABLE = "The gem name `%s' is not available."

    RUBYGEMS_URI = 'https://rubygems.org/api/v1/gems/%s.json'

    # @param [Io] io
    def initialize(io: Io.new)
      @io = io
      @shell = ShellHelper.new(io: io)
      @gh = GitHubHelper.new
    end

    def run(args)
      catch(:exit) do
        options = OptionParser.new.parse(args)
        config = build_config(options)
        generate_src(config)

        throw :exit, 0 if options.source?

        bundle_install(config)
        ensure_gem_name_available(config)
        setup_github_repo(config)

        0
      end
    end

    private

    def build_config(options)
      display_help(options, exit_code: 0) if options.help?
      display_help(options, exit_code: 1) if invalid_options?(options)
      apply_github_username(options)
      Configuration.build(options)
    end

    def invalid_options?(options)
      # TODO : there must be a single argument and it must be a valid gem-name
      options.arguments.size != 1
    end

    def display_help(options, exit_code: 0)
      @io.puts(options)
      throw :exit, exit_code
    end

    def apply_github_username(options)
      options[:github_username] ||= github_username
    end

    def github_username
      @gh.github_username
    rescue StandardError
      error_with(MISSING_GH_USERNAME)
    end

    def error_with(msg)
      @io.warn(msg)
      throw :exit, 1
    end

    def mkdir(dir)
      FileUtils.mkdir(dir) unless File.exist?(dir)
    end

    def generate_src(config)
      mkdir(config.gem_name)
      builder = Builder.new(config: config, io: @io)
      builder.generate_src(dir: dir)
    end

    def ensure_gem_name_available(config)
      # check to see if the gem name is available on RubyGems.org
      uri = URI.parse(format(RUBYGEMS_URI, config.gem_name))
      if Net::HTTP.get_response(uri).code.to_i != 404
        error_with(format(GEM_NAME_NOT_AVAILABLE, config.gem_name))
      end
    end

    def setup_github_repo(config)
      @gh.create_repo(
        name: config.gem_name,
        description: config.project_description,
        homepage: config.github_url
      )
      git_init_commit_push(config)
    rescue StandardError => e
      error_with("Failed to create github repository: #{e.message}")
    end

    def git_init_commit_push(config)
      Dir.chdir(config.gem_name) do
        sh('git init .')
        sh("git config user.name #{config.author_name.inspect}")
        sh("git config user.email #{config.author_email.inspect}")
        sh('git add .')
        sh('git commit -m "Add basic test, build, and release scripts"')
        sh("git remote add origin git@github.com:#{config.github_repo}.git")
        sh('git push -u origin master')
      end
    end

    def bundle_install(config)
      Dir.chdir(config.gem_name) do
        sh('bundle install')
        sh('rake test')
      end
    end

    def sh(command)
      @shell.exec(command)
    end

  end
end
