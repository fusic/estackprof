# frozen_string_literal: true

require 'stackprof'

module Estackprof
  def top(files:, options:)
    io = StringIO.new
    report_from(files).print_text(**parse_options(options), out: io)
    io.rewind
    io.read.to_s
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
    limit = options[:limit] || 10
    pattern = options[:pattern] && Regexp.new(options[:pattern])
    sort_by_total = options[:cumlative]
    { limit: limit, pattern: pattern, sort_by_total: sort_by_total }
  end

  module_function :top, :report_from, :parse_options
end
