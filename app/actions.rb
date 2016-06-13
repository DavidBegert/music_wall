# Homepage (Root path)
get '/' do
  erb :'index'
end

get '/music-wall' do
  erb :'music-wall/index'
end
