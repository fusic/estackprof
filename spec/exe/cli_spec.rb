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
    context 'when normal' do
      expected = <<~EXPECTED.chomp
        ==================================
          Mode: cpu(100)
          Samples: 99 (6.60% miss rate)
          GC: 8 (8.08%)
        ==================================
             TOTAL    (pct)     SAMPLES    (pct)     FRAME
                26  (26.3%)          26  (26.3%)     Enumerable#to_a
                23  (23.2%)          23  (23.2%)     File.expand_path
                 9   (9.1%)           9   (9.1%)     TCPSocket#initialize
      EXPECTED

      before do
        run_command(
          <<~CMD
            estackprof top --limit 3\
                          ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051311.dump\
                          ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051312.dump\
                          ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051313.dump
          CMD
        )
      end

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end

    context 'when cumlative' do
      expected = <<~EXPECTED.chomp
        ==================================
          Mode: cpu(100)
          Samples: 99 (6.60% miss rate)
          GC: 8 (8.08%)
        ==================================
             TOTAL    (pct)     SAMPLES    (pct)     FRAME
                88  (88.9%)           0   (0.0%)     WEBrick::GenericServer#start_thread(../../vendor/bundle/ruby/3.0.0/gems/webrick-1.7.0/lib/webrick/server.rb:288)
                86  (86.9%)           1   (1.0%)     WEBrick::HTTPServer#run(../../vendor/bundle/ruby/3.0.0/gems/webrick-1.7.0/lib/webrick/httpserver.rb:69)
                80  (80.8%)           0   (0.0%)     Sinatra::Base.call(../../vendor/bundle/ruby/3.0.0/gems/sinatra-2.1.0/lib/sinatra/base.rb:1541)
      EXPECTED

      before do
        run_command(
          <<~CMD
            estackprof top --limit 3 --cumlative\
                          ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051311.dump\
                          ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051312.dump\
                          ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051313.dump
          CMD
        )
      end

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end

    context 'when help' do
      expected = <<~EXPECTED.chomp
        Usage:
          estackprof top [..files]

        Options:
          -l, [--limit=N]                      # Limit reports.
          -p, [--pattern=PATTERN]              # Filter reports by pattern match.
          -c, [--cumlative], [--no-cumlative]  # Sort by cumulative count.
          -h, [--help], [--no-help]            # help message.
          -v, [--version], [--no-version]      # print version.
          -d, [--debug], [--no-debug]          # debug mode

        Report to top of methods
      EXPECTED

      before do
        run_command(
          <<~CMD
            estackprof help top
          CMD
        )
      end

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end
  end
end
