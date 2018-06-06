# frozen_string_literal: true

require 'mustache'

module GemBootstrap
  # @api private
  class SourceGenerator

    TEMPLATES_DIR = File.expand_path('../../templates', __dir__)

    # @param [Configuration] config
    def initialize(config:, templates_dir: TEMPLATES_DIR)
      @config = config
      @templates_dir = templates_dir
      @mustache = Mustache.new
      @mustache.raise_on_context_miss = true
      @mustache.template_path = templates_dir
    end

    # @return [String]
    attr_reader :templates_dir

    # @return [Enumerable<String,String>] Returns an enumerable of
    #   file paths and file contents as strings.
    def generate_src
      Enumerator.new do |y|
        Dir.glob("#{templates_dir}/**/{.*,*}.mustache").each do |template_path|
          y << [
            src_path(template_path),
            src_code(template_path),
          ]
        end
      end
    end

    private

    # The path contains two things that must be removed or replaced:
    #
    #   * Prune ".mustache" from the end of the string
    #   * Expand mustache variables, e.g. '{{gem_name}}'
    #
    def src_path(path)
      path = path[(templates_dir.length + 1)..-10]
      render(path)
    end

    def src_code(template_path)
      render(File.read(template_path))
    end

    def render(template)
      @mustache.render(template, @config)
    end

  end
end
