class UsersController < ApplicationController
  respond_to :html
  before_filter :logged?, :only=>[:edit,:edit_nick]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 10).order("id desc")
    @totalusers = User.count
    if request.xhr? 
      render :partial => @users
    end
    if (!session[:id].nil?)
      @user = User.find(session[:id])
    end
  end

  def search
    @users = User.where(["nick=?",params[:search_text]]).paginate(:page => params[:page], :per_page => 1).order(:nick)
    @totalusers = User.count
    if (!session[:id].nil?)
      @user = User.find(session[:id])
    end
    render "index"
  end

  def logout
    session[:id] = nil
    redirect_to :action=>"index"
  end
  
  def facebook_login
   info = request.env["omniauth.auth"]
   uid = info["uid"].to_s
   fbuser = User.where(["uid=?",uid]).limit(1).first
   if (fbuser.nil?)
      fbuser = User.new
      fbuser.uid = uid
      fbuser.name = info["user_info"]["name"].to_s
      fbuser.picture = info["user_info"]["image"].to_s
      fbuser.email = info["user_info"]["email"].to_s
      fbuser.save
    end
    session[:id] = fbuser.id
    redirect_to :action=>"edit"
  end

  def edit
    @user = User.find(session[:id])
  end
  
  def edit_nick
    @user = User.find(session[:id])
    @user.nick = params[:user][:nick]
    @user.save
    flash[:notice] = "Cadastro salvo!"
    redirect_to :action=>"index"
  end
end
