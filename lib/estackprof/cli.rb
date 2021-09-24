# frozen_string_literal: true

require 'thor'
require 'estackprof'

module Estackprof
  class CLI < Thor
    class_option :debug, type: :boolean, aliases: '-d', desc: 'debug mode'

    desc 'top [OPTIONS] [FILE...]', 'Report to top of methods'
    option :limit, aliases: '-l', desc: 'Limit reports.', type: :numeric
    option :pattern, aliases: '-p', desc: 'Filter reports by pattern match.'
    option :cumlative, aliases: '-c', desc: 'Sort by cumulative count.', type: :boolean
    def top(*files)
      puts Estackprof.top(
        files: files.empty? ? Dir.glob('./tmp/*.dump') : files,
        options: options
      )
      exit
    rescue StandardError => e
      output_error_if_debug_mode(e)
      exit(-1)
    end

    desc 'list [OPTIONS] [FILE...]', 'Display sample counts of each line'
    option :file, aliases: '-f', desc: 'Filter by file name.'
    option :method, aliases: '-m', desc: 'Filter by method name'
    def list(*files)
      puts Estackprof.list(
        files: files.empty? ? Dir.glob('./tmp/*.dump') : files,
        options: options
      )
      exit
    rescue StandardError => e
      output_error_if_debug_mode(e)
      exit(-1)
    end

    desc 'flamegraph [OPTIONS] [FILE]', 'Generate and open flamegraph'
    def flamegraph(*files)
      puts Estackprof.flamegraph(
        files: files.empty? ? Dir.glob('./tmp/*.dump') : files
      )
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
