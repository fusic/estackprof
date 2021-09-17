# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'estackprof'

use Estackprof::Middleware

def sort; end

def aaa; end

get '/' do
  JSON.parse('{ "hello": "world" }')['hello']
end
