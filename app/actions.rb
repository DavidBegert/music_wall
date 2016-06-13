# Homepage (Root path)
get '/' do
  erb :'index'
end

get '/music_wall' do
  @songs = Song.all
  erb :'music_wall/index'
end

get '/music_wall/new' do 
  @song = Song.new
  erb :'music_wall/new'
end

post '/music_wall' do 
  @song = Song.new(
    title: params[:title],
    artist: params[:artist],
    url: params[:url]
    )

  if @song.save
    redirect '/music_wall'
  else
    erb :'music_wall/new'
  end

end