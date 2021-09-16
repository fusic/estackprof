# frozen_string_literal: true

require 'thor'
require 'pry'
require 'estackprof'

module Estackprof
  class CLI < Thor
    class_option :help, type: :boolean, aliases: '-h', desc: 'help message.'
    class_option :version, type: :boolean, aliases: '-v', desc: 'print version.'
    class_option :debug, type: :boolean, aliases: '-d', desc: 'debug mode'

    desc 'top [..files]', 'Report to top of methods'
    def top(*files)
      puts Estackprof.top(files: files.empty? ? Dir.glob('./tmp/*.dump') : files)
      exit
    rescue StandardError => e
      output_error_if_debug_mode(e)
      exit(-1)
    end

    map %w[--version -v] => :version
    desc 'version', 'version'
    def version
      puts Estackprof::VERSION
    end

    private

    def output_error_if_debug_mode(exception)
      return unless options[:debug]

      warn(exception.message)
      warn(exception.backtrace)
    end

    class << self
      private

      def exit_on_failure?
        true
      end
    end
  end
end
