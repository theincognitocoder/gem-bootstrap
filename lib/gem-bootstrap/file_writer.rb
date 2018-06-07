# frozen_string_literal: true

require 'rainbow'

module GemBootstrap
  # @api private
  class FileWriter

    def initialize(io:)
      @conflicts = FileConflictManager.new(io: io)
      @io = io
    end

    def write(file_path, file_contents)
      if File.exist?(file_path)
        handle_file_exists(file_path, file_contents)
      else
        handle_new_file(file_path, file_contents)
      end
    end

    private

    def handle_new_file(file_path, file_contents)
      directory = File.dirname(file_path)
      FileUtils.mkdir_p(directory) unless File.exist?(directory)
      File.write(file_path, file_contents)
      log('create', :green, file_path)
    end

    # @param [String] file_path
    # @param [String] file_contents
    def handle_file_exists(file_path, file_contents)
      old_contents = File.read(file_path)
      new_contents = file_contents
      if old_contents == new_contents
        log('identical', :white, file_path)
      else
        handle_file_conflict(file_path, old_contents, new_contents)
      end
    end

    # @param [String] file_path
    # @param [String] old
    # @param [String] new
    def handle_file_conflict(file_path, old, new)
      if @conflicts.overwrite_all?
        log('force', :yellow, file_path)
        File.write(file_path, new)
        return
      end

      log('conflict', :red, file_path)
      if @conflicts.should_overwrite?(file_path, old, new)
        log('force', :yellow, file_path)
        File.write(file_path, new)
      else
        log('skip', :yellow, file_path)
      end
    end

    # @param [String] action
    # @param [Symbol] color
    # @param [String] file_path
    def log(action, color, file_path)
      action = Rainbow(format('%13s', action)).bold.send(color)
      @io.puts(action + ' ' + file_path)
    end

  end
end
