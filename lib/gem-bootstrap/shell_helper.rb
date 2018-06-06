# frozen_string_literal: true

require 'open3'

module GemBootstrap
  # @api private
  class ShellHelper

    # @param [Io] io
    def initialize(io: Io.new)
      @io = io
    end

    def exec(command)
      # $CHILD_STATUS.exitstatus
      # $CHILD_STATUS.pid
      # TODO : deal with errors
      # TODO : direct input/output of the command to @input and @output
      system(command)
    end

  end
end
