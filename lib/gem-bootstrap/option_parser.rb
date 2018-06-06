# frozen_string_literal: true

require 'slop'

module GemBootstrap
  # @api private
  class OptionParser

    def parse(args)
      Slop.parse(args, banner: banner) do |o|
        o.string '--author', 'Author name'
        o.string '--email', 'Author email'
        o.string '--github-username'
        o.bool '--source', 'Only generate source'
        o.bool '-h', '--help'
      end
    end

    private

    def banner
      "usage: gem-boostrap \033[4mgem_name\033[0m [options]"
    end

  end
end
