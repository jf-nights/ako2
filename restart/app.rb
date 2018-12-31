Bundler.require
require 'sinatra/reloader'
require 'open3'
require_relative 'config'

get '/' do
  erb :index
end

get '/restart' do
  puts "restart coming"
  stdin, stdout, stderr, wait_thr = Open3.popen3("./restart.sh")
  redirect(back)
end
