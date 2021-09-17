# frozen_string_literal: true

require 'stackprof'

module Estackprof
  def top(files:, options:)
    io = StringIO.new
    report_from(files).print_text(**parse_options(options), out: io)
    io.rewind
    "#{io.read}\n"
  rescue StandardError
    puts 'Dump files are missing or incorrect.'
  end

  private

  def report_from(files)
    reports = files.map do |file|
      Estackprof::Report.new(Marshal.load(IO.binread(file)))
    end
    reports.inject(:+)
  end

  def parse_options(options)
    limit = options[:limit] ? options[:limit].to_i : 10
    pattern = Regexp.new(options[:pattern]) if options[:pattern]
    { limit: limit, pattern: pattern }
  end

  module_function :top, :report_from, :parse_options
end
