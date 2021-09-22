# frozen_string_literal: true

require 'stackprof'

module Estackprof
  class Middleware < StackProf::Middleware
    def initialize(app, options = {})
      options[:enabled] = true if options[:enabled].nil?
      options[:raw] = true if options[:raw].nil?
      options[:save_every] ||= 10

      super(app, **options)
    end

    class << self
      %i[enabled mode interval raw path metadata].each do |sym|
        define_method(sym) do
          StackProf::Middleware.send(sym)
        end
        define_method("#{sym}=") do |value|
          StackProf::Middleware.send("#{sym}=", value)
        end
      end
    end
  end
end
