# frozen_string_literal: true

require 'active_support'

module GemBootstrap
  # @api private
  class Configuration

    def initialize(
      project_name:,
      module_name:,
      gem_name:,
      author_name:,
      author_email:,
      github_username:
    )
      @project_name = project_name
      @module_name = module_name
      @gem_name = gem_name
      @author_name = author_name
      @author_email = author_email
      @project_description = project_name
      @github_username = github_username
      @github_repo = "#{github_username}/#{gem_name}"
      @year = Time.now.utc.year
      @docs_url = "https://www.rubydoc.info/github/#{github_repo}/master"
      @gitter_url = "https://gitter.im/#{github_username}"
      @github_url = "https://github.com/#{github_repo}"
      @changelog_url = @github_url + 'blob/master/CHANGELOG.md'
    end

    # @return [String]
    attr_reader :project_name

    # @return [String]
    attr_reader :project_description

    # @return [String]
    attr_reader :module_name

    # @return [String]
    attr_reader :gem_name

    # @return [String]
    attr_reader :author_name

    # @return [String]
    attr_reader :author_email

    # @return [String]
    attr_reader :github_username

    # @return [String]
    attr_reader :github_repo

    # @return [Integer]
    attr_reader :year

    # @return [String]
    attr_reader :docs_url

    # @return [String]
    attr_reader :gitter_url

    # @return [String]
    attr_reader :github_url

    # @return [String]
    attr_reader :changelog_url

    class << self

      # @param [Slop::Options] options
      def build(options)
        gem_name = options.arguments.first
        new(
          project_name: project_name(gem_name),
          module_name: module_name(gem_name),
          gem_name: gem_name,
          author_name: author(options),
          author_email: email(options),
          github_username: options[:github_username]
        )
      end

      private

      def gem_name(options)
        options.arguments.first
      end

      def project_name(gem_name)
        ActiveSupport::Inflector.titleize(gem_name)
      end

      def module_name(gem_name)
        ActiveSupport::Inflector.camelize(
          ActiveSupport::Inflector.underscore(gem_name)
        )
      end

      def author(options)
        options[:author] || `git config user.name`.strip
      end

      def email(options)
        options[:email] || `git config user.email`.strip
      end

    end

  end
end
