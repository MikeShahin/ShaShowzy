class UsersController < ApplicationController

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to '/protests'
    end
  end

  post '/login' do

    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to "/dashboard"
    else
        flash[:error] = "Sorry, password/username does not match"
        redirect to '/login'
    end
  end

  post '/logout' do
        session.destroy
        redirect to '/'
  end

  get '/signup' do
    if !logged_in?
      erb :'users/signup'
    else
      redirect to '/dashboard'
    end
  end

  post '/signup' do
    if empty_fields?
      flash[:error] = "Please correctly fill out all fields."
      redirect to '/signup'
    elsif user_exists?
      flash[:error] = "Sorry, this name is already taken, please choose a different one"
      redirect to '/signup'
    else
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      session[:user_id] = @user.id
      redirect to '/dashboard'
    end
  end

  get '/dashboard' do
    @user = User.find_by(id: session[:user_id])
    @protests = Protest.where(:user_id => session[:user_id])
    if logged_in?
      erb :'users/dashboard'
    else 
      redirect to '/login'
    end
  end
end