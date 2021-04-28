Bundler.require
require 'sinatra/reloader'
require_relative './sinatra/config'

get "/" do
  "hello~~~~"
end
