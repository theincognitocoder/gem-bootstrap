# frozen_string_literal: true

require 'diffy'

module GemBootstrap
  # @api private
  class FileConflictManager

    PROMPT = 'Overwrite %<path>s? (enter "h" for help) [ynaqdh]: '

    def initialize(io:)
      @io = io
      @overwrite_all = false
    end

    # @return [Boolean]
    def overwrite_all?
      @overwrite_all
    end

    # @return [Boolean] Returns `true` if the file should be overwritten
    def should_overwrite?(file_path, old_contents, new_contents)
      if @overwrite_all
        true
      else
        ask(file_path, old_contents, new_contents)
      end
    end

    private

    def ask(path, old, new)
      loop do
        case prompt(path).downcase.strip
        when 'y' then return true
        when 'n' then return false
        when 'a' then return @overwrite_all = true
        when 'q' then throw :exit, 0
        when 'd' then print_diff(old, new)
        else print_help
        end
      end
    end

    def prompt(file_path)
      @io.write(format(PROMPT, path: file_path))
      @io.readline.downcase.strip
    end

    def print_diff(left, right)
      @io.write("\n")
      @io.write(Diffy::Diff.new(left, right).to_s(:color))
      @io.write("\n")
    end

    def print_help
      @io.write(<<-HELP)
        y - yes, overwrite
        n - no, skip this file
        a - all, overwrite this and all others
        q - quit, abort
        d - diff, show the differences
        h - help, show this help
      HELP
    end

  end
end
