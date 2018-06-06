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

    def prompt(string, default: nil)
      question = prompt_string(string, default)
      response = nil
      while response.nil?
        write(question)
        response = readline.strip
        response = default if response.empty?
      end
      response
    end

    def prompt_string(string, default)
      if default.nil?
        format('%<p>s: ', p: string)
      else
        format('%<p>s [%<d>s]: ', p: string, d: default.to_s)
      end
    end

  end
end
