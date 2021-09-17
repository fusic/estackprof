# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'estackprof command', type: :aruba do
  context 'with version option' do
    before { run_command('estackprof v') }

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output('0.1.0') }
  end

  context 'with help option' do
    expected = <<~EXPECTED
      Commands:
        estackprof help [COMMAND]  # Describe available commands or one specific co...
        estackprof top [..files]   # Report to top of methods
        estackprof version         # version

      Options:
        -h, [--help], [--no-help]        # help message.
        -v, [--version], [--no-version]  # print version.
        -d, [--debug], [--no-debug]      # debug mode
    EXPECTED

    before { run_command('estackprof help') }

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end

  context 'when top subcommand' do
    expected = <<~EXPECTED
      ==================================
        Mode: cpu(100)
        Samples: 99 (6.60% miss rate)
        GC: 8 (8.08%)
      ==================================
           TOTAL    (pct)     SAMPLES    (pct)     FRAME
              26  (26.3%)          26  (26.3%)     Enumerable#to_a
              23  (23.2%)          23  (23.2%)     File.expand_path
               9   (9.1%)           9   (9.1%)     TCPSocket#initialize
               8   (8.1%)           8   (8.1%)     (sweeping)
               5   (5.1%)           5   (5.1%)     File.exist?
               3   (3.0%)           3   (3.0%)     IO#write_nonblock
               3   (3.0%)           3   (3.0%)     Thread.start
               2   (2.0%)           2   (2.0%)     IO.select
               2   (2.0%)           2   (2.0%)     String#downcase
               2   (2.0%)           2   (2.0%)     IPSocket#peeraddr
               1   (1.0%)           1   (1.0%)     block in set(../../vendor/bundle/ruby/3.0.0/gems/sinatra-2.1.0/lib/sinatra/base.rb:1277)
               1   (1.0%)           1   (1.0%)     Kernel#method
              13  (13.1%)           1   (1.0%)     Net::HTTP#do_start(../../../../../../.asdf/installs/ruby/3.0.1/lib/ruby/3.0.0/net/http.rb:969)
               1   (1.0%)           1   (1.0%)     MatchData#[]
               1   (1.0%)           1   (1.0%)     String#to_sym
               1   (1.0%)           1   (1.0%)     IO#eof?
               1   (1.0%)           1   (1.0%)     IO#wait_readable
               1   (1.0%)           1   (1.0%)     String#include?
               2   (2.0%)           1   (1.0%)     Sinatra::Helpers#content_type(../../vendor/bundle/ruby/3.0.0/gems/sinatra-2.1.0/lib/sinatra/base.rb:362)
               1   (1.0%)           1   (1.0%)     URI::Generic#initialize(../../../../../../.asdf/installs/ruby/3.0.1/lib/ruby/3.0.0/uri/generic.rb:169)
    EXPECTED

    before do
      run_command(
        <<~CMD
          estackprof top ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051311.dump\
                         ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051312.dump\
                         ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051313.dump
        CMD
      )
    end

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end
end
