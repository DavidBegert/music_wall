# Homepage (Root path)
  set sessions: true

  helpers do 
    def logged_in?
      @user != nil
    end
  end

  before do
    @user = User.find_by(id: session[:user_id])
  end

  get '/' do
    erb :'index'
  end

  get '/music_wall' do
    @songs = Song.all.sort_by { |s| s.votes.count }
    @songs.reverse!
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

  get '/music_wall/:title' do |title|
    @song = Song.find_by(title: title)
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
    if User.authenticate(params)
      session[:user_id] = User.authenticate(params).id
      redirect '/'
    else
      erb :'login/index'
    end
  end

  get "/logout" do
    session.clear #or [:user_id] = nil
    redirect '/'
  end

  get "/vote/upvote/:id" do |song_id|
    if logged_in?
      vote = Vote.new(user_id: @user.id, song_id: song_id)
      if vote.save
        redirect '/music_wall'
      else
        #TOTO put message saying u cant vote for the same song more than once
        redirect '/music_wall'
      end
    else
      #TODO put a message saying u must be logged in to vote
      redirect '/music_wall'
    end
  end
