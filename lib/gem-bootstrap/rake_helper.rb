# frozen_string_literal: true

module GemBootstrap
  # @api private
  class RakeHelper

    # @param [IO] output
    def initialize(output: $stdout)
      @output = output
    end

    # @return [IO]
    attr_reader :output

    def test
      sh('rake test')
    end

  end
end
