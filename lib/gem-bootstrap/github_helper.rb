# frozen_string_literal: true

require 'octokit'

module GemBootstrap
  # @api private
  class GitHubHelper

    def initialize
      @octokit = Octokit::Client.new(octokit_creds)
    end

    def create_repo(name:, description:, homepage:)
      @octokit.create_repository(
        name,
        description: description,
        homepage: homepage,
        private: false,
        has_issues: true,
        has_wiki: true,
        has_downloads: true,
        organization: nil,
        team_id: nil,
        auto_init: false,
        gitignore_template: nil
      )
    end

    def github_username
      @octokit.user[:login]
    end

    private

    def octokit_creds
      if ENV['GITHUB_ACCESS_TOKEN']
        { access_token: ENV['GITHUB_ACCESS_TOKEN'] }
      else
        { netrc: true }
      end
    end

  end
end
