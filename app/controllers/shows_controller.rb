class showsController < ApplicationController

  get "/shows" do
    @shows = show.all.sort_by {|p| p.date }
    erb :"/shows/show"
  end

  get "/shows/new" do
    if logged_in?
      erb :'shows/new_show'
    else 
      redirect to '/login'
    end
  end

  post '/shows' do
    if logged_in?
      if empty_fields?
        flash[:error] = "Please fill out all the fields"
        redirect to '/shows/new'
      else
        @show = current_user.shows.build(name: params[:name], location: params[:location], description: params[:description], date: params[:date], time: params[:time])
        if @show.save
          redirect to "/shows/#{@show.id}"
        else
          flash[:error] = "Sorry something went wrong! Try again"
          redirect to '/shows/new'
        end
      end
    else
      redirect to 'login'
    end
  end

  get '/shows/:id' do
    find_show
      erb :'shows/show_show'
  end

  get '/shows/:id/edit' do
    if logged_in?
      find_show
      if @show && @show.user == current_user
        erb :'shows/edit'
      else
        flash[:error] = "Sorry, you do not have permission to edit this event"
        redirect to '/shows'
      end
    else
      flash[:error] = "Please login to edit this event"
      redirect to '/login'
    end
  end

  patch '/shows/:id' do
    not_logged_in
    
      if empty_fields?
        flash[:error] = "Please fill out all fields"
        redirect to "/shows/#{params[:id]}/edit"
      else
        find_show
        if @show && @show.user == current_user
          if @show.update(name: params[:name], location: params[:location], description: params[:description], date: params[:date], time: params[:time])
            redirect to "/shows/#{@show.id}"
          else
            flash[:error] = "Sorry, something went wrong, please try again"
            redirect to "/shows/#{@show.id}/edit"
          end
        else
          redirect to '/shows'
        end
      end
  end

  delete '/shows/:id/delete' do
    if logged_in?
      find_show
      if @show && @show.user == current_user
        @show.delete
      end
      redirect to '/shows'
    else
      redirect to '/login'
    end
  end

  private
  def find_show
    @show = show.find_by_id(params[:id])
  end

end