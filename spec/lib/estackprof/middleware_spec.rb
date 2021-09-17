# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Estackprof::Middleware do
  before do
    described_class.new(nil)
  end

  it { expect(described_class.mode).to eq(:cpu) }
  it { expect(described_class.enabled).to eq(true) }

  it do
    described_class.mode = :wall
    expect(described_class.mode).to eq(:wall)
  end
end
