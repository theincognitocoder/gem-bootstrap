# frozen_string_literal: true

module GemBootstrap
  # @api private
  class Io

    def initialize(input: $stdin, output: $stdout, error: $stderr)
      @input = input
      @output = output
      @error = error
    end

    def puts(string)
      @output.puts(string)
    end

    def write(string)
      @output.write(string)
    end

    def warn(string)
      @error.puts(string)
    end

    def readline
      @input.readline
    end

  end
end
