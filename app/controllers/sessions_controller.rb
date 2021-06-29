class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new,:create]

  def new
  end

  def create
    #Userテーブルから"session"パラメータの"email"を取得し検索してuserに代入する。
    #userには"name","email","password"が入る
    user = User.find_by(email: params[:session][:email].downcase)

    #1.authenticate = userに入っているパスワードとparams:passwordを比較する。
    #2.合っていたら userを返す，違っていたらfalseを返す
    #3.user && user => Rubyは文字列はtrue扱いなので ture && tureの式になる。
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

end
