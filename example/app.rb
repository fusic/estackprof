# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'estackprof'

use Estackprof::Middleware

def bubble_sort(array)
  ary = array.dup
  pos_max = ary.size - 1

  (0...pos_max).each do |n|
    (0...(pos_max - n)).each do |ix|
      iy = ix + 1
      ary[ix], ary[iy] = ary[iy], ary[ix] if ary[ix] > ary[iy]
    end
  end

  ary
end

get '/' do
  array = Array.new(1000) { rand(10_000) }
  bubble_sort(array).to_s
end
