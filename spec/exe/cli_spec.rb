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
        estackprof fizzbuzz [limit]  # Get fizzbuzz result from limit number
        estackprof help [COMMAND]    # Describe available commands or one specific ...
        estackprof version           # version

      Options:
        -h, [--help], [--no-help]        # help message.
        -v, [--version], [--no-version]  # print version.
        -d, [--debug], [--no-debug]      # debug mode
    EXPECTED

    before { run_command('estackprof help') }

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end

  context 'when fizzbuzz subcommand' do
    expected = %w[FizzBuzz 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz].join(',')
    before { run_command('estackprof fizzbuzz 15') }

    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }

    context 'with invalid args' do
      before { run_command('estackprof fizzbuzz a') }

      it { expect(last_command_started).not_to be_successfully_executed }
    end
  end
end
