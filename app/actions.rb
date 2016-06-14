# Homepage (Root path)
set sessions: true

helpers do 
  def logged_in?
    @user != nil
  end

  def current_user
    @user
  end
end

before do
  @user = User.find_by(id: session[:user_id])
end

get '/' do
  erb :'index'
end

get '/music_wall' do
  @songs = Song.includes(:votes).group(:id).order("count(votes.id) DESC").references(:votes)
  erb :'music_wall/index'
end

get '/music_wall/new' do 
  @song = Song.new
  if logged_in?
    erb :'music_wall/new'
  else
    #TODO put in a message saying you must be logged in to post a new song
    redirect '/'
  end
end

post '/music_wall' do 
  @song = Song.new(
    title: params[:title],
    artist: params[:artist],
    url: params[:url],
    user_id: @user.id  #session[:user_id]
    )

  if @song.save
    redirect '/music_wall'
  else
    erb :'music_wall/new'
  end

end

get '/music_wall/:id' do |id|
  @song = Song.find_by(id: id)
  erb :'music_wall/show'
end

# get '/register' do 
#   erb :'login/new'
# end

get '/login' do 
  erb :'login/index'
end

get '/login/new' do
  erb :'login/new'
end

post "/login/new" do
  @user = User.new(
    username: params[:username],
    email: params[:email],
    password: Digest::SHA1.hexdigest(params[:password])
    )
  if @user.save
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'login/new'
  end
end

post "/login" do
  valid_user = User.authenticate(params)
  if valid_user
    session[:user_id] = valid_user.id
    redirect '/'
  else
    erb :'login/index'
  end
end

get "/logout" do
  session.clear #or [:user_id] = nil
  redirect '/'
end

get "/vote/upvote/:song_id" do  #post to /songs/vote have hidden value that refers to song id in form
  if logged_in?
    vote = Vote.new(user_id: @user.id, song_id: params[:song_id])
    if vote.save
      redirect '/music_wall'
    else
      flash[:info] = "You cannot vote for the same song more than once!"
      redirect '/music_wall'
    end
  else
    session[:login] = "You must be logged in to vote!"
    redirect '/music_wall'
  end
end

post "/music_wall/review/new/:id" do
    @review = Review.new(user_id: @user.id, song_id: params[:id], post: params[:post], rating: params[:rating])
    if @review.save
      redirect "/music_wall/#{params[:id]}"
    else
      #TODO give error messages for why it couldnt be saved. 
      @song = Song.find(params[:id])
      erb :'/music_wall/show'
    end

end

get '/delete/review/:id' do |review_id|
  review = Review.find(review_id)
  song_id = review.song_id
  review.destroy
  redirect "/music_wall/#{song_id}"

end
