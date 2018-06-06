# frozen_string_literal: true

require 'diffy'
require 'rainbow'

module GemBootstrap
  # @api private
  class FileWriter

    def initialize(io:)
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
      log(Rainbow('       create').bold.green, file_path)
    end

    # @param [String] file_path
    # @param [String] file_contents
    def handle_file_exists(file_path, file_contents)
      old_contents = File.read(file_path)
      new_contents = file_contents
      if old_contents == new_contents
        log(Rainbow('    identical').bold.white, file_path)
      else
        handle_file_conflict(file_path, old_contents, new_contents)
      end
    end

    # @param [String] file_path
    # @param [String] old_contents
    # @param [String] new_contents
    def handle_file_conflict(file_path, old_contents, new_contents)
      # TODO : handle conflicts
      log(Rainbow('     conflict').bold.yellow, file_path)
      print("\n")
      print(Diffy::Diff.new(old_contents, new_contents).to_s(:color))
      print("\n")
    end

    # @param [String] action
    # @param [String] file_path
    def log(action, file_path)
      @io.puts("#{action} #{file_path}")
    end

  end
end
