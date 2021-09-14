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
        estackprof top [...files]  # Report to top of methods
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
        Samples: 40 (2.44% miss rate)
        GC: 5 (12.50%)
      ==================================
           TOTAL    (pct)     SAMPLES    (pct)     FRAME
              13  (32.5%)          13  (32.5%)     Enumerable#to_a
               6  (15.0%)           6  (15.0%)     File.expand_path
               5  (12.5%)           5  (12.5%)     (sweeping)
               3   (7.5%)           3   (7.5%)     File.exist?
               3   (7.5%)           3   (7.5%)     TCPSocket#initialize
    EXPECTED

    before do
      run_command('estackprof top ../../spec/fixtures/dump/case1/stackprof-cpu-13332-1631051311.dump')
    end

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end
end
