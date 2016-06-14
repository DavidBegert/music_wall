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

  get '/music_wall/:title' do |title|
    @song = Song.find_by(title: title)
    erb :'music_wall/show'
  end

  get '/register' do 
    erb :'login/new'
  end

  get '/login' do 
    erb :'login/index'
  end

  post "/login/new" do
    @user = User.new(
      username: params[:username],
      email: params[:email],
      password: params[:password]
      )
    if @user.save
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
    session[:user_id] = nil
  end
