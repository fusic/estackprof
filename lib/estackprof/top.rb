# frozen_string_literal: true

require 'stackprof'

module Estackprof
  def top(files:, limit:, include: nil)
    reports = files.map do |file|
      Estackprof::Report.new(Marshal.load(IO.binread(file)))
    end
    report = reports.inject(:+)

    io = StringIO.new
    report.print_text(limit: limit, out: io)
    io.rewind
    "#{io.read}\n"
  rescue StandardError
    puts 'Dump files are missing or incorrect.'
  end

  module_function :top
end
