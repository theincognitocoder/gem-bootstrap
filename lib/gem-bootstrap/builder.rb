# frozen_string_literal: true

module GemBootstrap
  # @api private
  class Builder

    # @param [Configuration] config
    # @param [Io] io
    def initialize(config:, io:)
      @generator = SourceGenerator.new(config: config)
      @file_writer = FileWriter.new(io: io)
    end

    # @param [String] dir
    # @return [Enumerable<String,String>] Returns an enumerable of
    #   file paths and file contents as strings.
    def generate_src(dir:)
      @generator.generate_src.each do |file_path, file_contents|
        @file_writer.write(File.join(dir, file_path), file_contents)
      end
    end

  end
end
