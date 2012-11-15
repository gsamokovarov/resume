require 'fileutils'
require 'yaml'
require 'rubygems'

require 'rake'
require 'tilt'

module Project
  #: { Augmented builtins...
  class ::Array
    def second
      self[1]
    end
  end
  #: }

  module Util
    class ItemGetter
      def initialize(object)
        @object = object
      end

      def [](key)
        raise NoMethodError unless @object.respond_to? :[]

        if key.is_a? String or key.is_a? Symbol
          key = key.to_s if key.is_a? Symbol

          unless key.include? '.'
            return self.class.new(@object[key]) if @object[key].is_a? Hash
            return @object[key]
          end

          parts = key.split '.'

          return self.class.new(@object[parts.first])[parts[1..-1].join('.')] \
            if @object[parts.first].is_a? Hash and not parts.second.nil?
        end

        # There is nothing more we can do when we get here.
        @object[key]
      end

      def inspect
        @object.inspect
      end

      public

      def method_missing(name, *args, &block)
        return self[name.to_s] unless @object.respond_to? name

        @object.send(name, *args, &block)
      end
    end
  end

  class Config
    #
    # Thrown when a config file is not found.
    #
    class NotFound < LoadError; end

    #
    # Loads configuration from YAML file.
    #
    def self.from_file(filename)
      File.open(filename) { |f|
        self.new(f)
      }
    rescue Errno::ENOENT => e
      raise NotFound, e
    end

    # Alias for the constructor.
    class << self
      alias load new
    end

    def initialize(config)
      @config = YAML.load(config)
    end

    def [](key)
      Util::ItemGetter.new(@config)[key.to_s]
    end
    alias get []

    def []=(key, value)
      @config[key] = value
    end
    alias set []=

    public

    def method_missing(name, *args, &block)
      self[name.to_s]
    end
  end
end

#: { Cleaning helpers...
namespace :clean do
  desc "Cleans the unneeded tildas."
  task :tildas do
    Dir.glob('*~') { |fn| FileUtils.rm fn }
  end

  desc "Cleans the vim leftovers."
  task :vim do
    Dir.glob('.*.sw[a-z]') { |fn| FileUtils.rm fn }
  end
end

desc "Cleans everything"
task :clean => %w{clean:vim clean:tildas}
#: }

namespace :development do
  desc "Runs the tests for the project."
  task :test do
    ruby "test/test_project.rb"
  end

  desc "Creates an archive for the project"
  task :release do
    sh "tar -czf cv.tar.gz *"
  end
end

task :test => :'development:test'
task :release => :'development:release'

desc "Compiles the template into HTML file."
task :compile do
  config = begin
    Project::Config.from_file('config.yaml')
  rescue Project::Config::NotFound
     Project::Config.load(DATA)
  end

  File.open(config.files.output, 'w') { |f|
    f.write Tilt.new(config.files.layout).render(Object.new, {
      :inlined_style => Tilt.new(config.files.style).render
    })
  }
end

task :default => :compile

__END__
files:
  output: public/layout.html
  layout: templates/layout.haml
  style: templates/style.sass
