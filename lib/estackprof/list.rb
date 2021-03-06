# frozen_string_literal: true

require 'stackprof'

module Estackprof
  def list(files:, options:)
    io = StringIO.new

    print_by_options(Report.create(files), options, io)

    io.rewind
    io.read.to_s
  rescue StandardError
    puts 'Dump files are missing or incorrect.'
  end

  private

  def print_by_options(report, options, io)
    if options[:method]
      report.print_method(options[:method], io)
    elsif options[:file]
      report.print_file(options[:file], io)
    else
      report.print_files(false, nil, io)
    end
  end

  module_function :list, :print_by_options
end
