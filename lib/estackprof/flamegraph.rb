# frozen_string_literal: true

require 'stackprof'
require 'launchy'

module Estackprof
  def flamegraph(files:)
    File.open('./tmp/flamegraph.html', 'w') do |f|
      report_from([files[0]]).print_d3_flamegraph(f)
    end
    html_path = File.expand_path('./tmp/flamegraph.html')
    Launchy.open(html_path)
    html_path
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

  module_function :flamegraph, :report_from
end
