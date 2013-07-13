require 'sinatra'
require 'json'

use Rack::Auth::Basic do |username, password|
  username == 'nyan' && password == 'cat'
end

get '/api/nyan' do
  if params[:format] == "xml"
    "<nyan>cat</nyan>"
  else
    JSON.dump({ nyan: "cat" })
  end
end

delete '/api/nyan' do
end

head '/api/nyan' do
end

options '/api/nyan' do
end

put '/api/nyan' do
  JSON.parse(request.body.read)
  [204]
end

post '/api/nyan' do
  data = JSON.parse(request.body.read)
  [201, JSON.dump(data)]
end

patch '/api/nyan' do
end
