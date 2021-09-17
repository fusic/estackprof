# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Estackprof do
  describe 'Estackprof.parse_options' do
    let(:parse_options) do
      described_class.send(:parse_options, { limit: 5, pattern: 'aa' })
    end

    describe ':limit' do
      subject { parse_options[:limit] }

      it { is_expected.to eq(5) }
    end

    describe ':pattern' do
      subject { parse_options[:pattern] }

      it { is_expected.to eq(/aa/) }
    end
  end
end
