# frozen_string_literal: true

require 'stackprof'

module Estackprof
  class Middleware < StackProf::Middleware
    def initialize(app)
      super(app, enabled: true, save_every: 5, raw: true)
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
