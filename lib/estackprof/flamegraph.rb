# frozen_string_literal: true

require 'stackprof'
require 'launchy'

module Estackprof
  def flamegraph(files:)
    mkdir(tmp_path = './tmp')
    html_path = File.expand_path("#{tmp_path}/flamegraph.html")
    File.open(html_path, 'w') { |f| Report.create([files[0]]).print_d3_flamegraph(f) }
    Launchy.open(html_path)
    html_path
  rescue StandardError
    puts 'Dump files are missing or incorrect.'
  end

  private

  def mkdir(path)
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)
  end

  module_function :flamegraph, :mkdir
end
