# frozen_string_literal: true

require 'stackprof'

module Estackprof
  def top(files)
    reports = files.map do |file|
      StackProf::Report.new(Marshal.load(IO.binread(file)))
    end
    report = reports.inject(:+)

    io = StringIO.new
    report.print_text(*default_options(io))
    io.rewind
    "#{io.read}\n"
  end

  def default_options(io)
    [
      false,
      5,
      nil,
      nil,
      nil,
      nil,
      io
    ]
  end

  module_function :top, :default_options
end
