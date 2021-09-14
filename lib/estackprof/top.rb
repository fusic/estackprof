# frozen_string_literal: true

require 'stackprof'

module Estackprof
  def top(files)
    reports = files.map do |file|
      Estackprof::Report.new(Marshal.load(IO.binread(file)))
    end
    report = reports.inject(:+)

    io = StringIO.new
    report.print_text(limit: 20, out: io)
    io.rewind
    "#{io.read}\n"
  end

  module_function :top
end
