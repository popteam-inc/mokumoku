class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :forbid_login_user, {only: [:new, :login, :create, :forbid_login_user]}

  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      flash[:notice] ="ユーザー登録しました"
      redirect_to("/users/#{@user.id}")
    else
      render("/users/new")
    end
  end

  def edit 
   @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if @user.save
      flash[:notice] = "編集いたしましたでござる"
      redirect_to("/users/index")
    else
      render("users/:id/edit")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
  end

  def login_form
    
  end

  def login
    @user = User.find_by(
      email: params[:email],
      password: params[:password]
    )
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインしたよん"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスかパスワードが違うみたい"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしたよん"
  end
end
