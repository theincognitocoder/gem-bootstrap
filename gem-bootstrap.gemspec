# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'gem-bootstrap'
  spec.version       = File.read(File.expand_path('VERSION', __dir__)).strip
  spec.summary       = 'CLI for bootstrapping new Ruby gem projects.'
  spec.description   = 'Bootstraps a Ruby gem project.'
  spec.authors       = ['The Incognito Coder']
  spec.email         = ['theincognitocoder@gmail.com']
  spec.homepage      = 'https://github.com/theincognitocoder/gem-bootstrap'
  spec.license       = 'MIT'
  spec.require_paths = ['lib']
  spec.files         = Dir['lib/**/*.rb', 'templates/*.mustache']
  spec.bindir        = 'bin'
  spec.executables   = ['gem-boostrap']

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/theincognitocoder/gem-bootstrap/issues',
    'changelog_uri'     => 'https://github.com/theincognitocoder/gem-bootstrap/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/github/theincognitocoder/gem-bootstrap/master',
    'homepage_uri'      => 'https://github.com/theincognitocoder/gem-bootstrap',
    'source_code_uri'   => 'https://github.com/theincognitocoder/gem-bootstrap',
  }

  spec.add_dependency('activesupport', '~> 5.2')
  spec.add_dependency('diff-lcs', '~> 1.3')
  spec.add_dependency('diffy', '~> 3.2')
  spec.add_dependency('mustache', '~> 1.0')
  spec.add_dependency('netrc', '~> 0.11')
  spec.add_dependency('octokit', '~> 4.9')
  spec.add_dependency('rainbow', '~> 3.0')
  spec.add_dependency('rake', '~> 12.3')
  spec.add_dependency('semver-string', '~> 1.0')
  spec.add_dependency('slop', '~> 4.6')
  spec.add_dependency('travis', '~> 1.8')

  spec.add_development_dependency('coveralls', '~> 0.8')
  spec.add_development_dependency('kramdown', '~> 1.16')
  spec.add_development_dependency('pry', '~> 0.11')
  spec.add_development_dependency('rake', '~> 12.3')
  spec.add_development_dependency('rspec', '~> 3.7')
  spec.add_development_dependency('rubocop', '~> 0.56')
  spec.add_development_dependency('yard', '~> 0.9')
  spec.add_development_dependency('yard-sitemap', '~> 1.0')
end
