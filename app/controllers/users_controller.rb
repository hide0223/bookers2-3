class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @books = @user.books
    @book = Book.new
    @user = User.find(params[:id]) #ユーザーモデルからparams[:id]が一致するレコードを取得（指定されたIDのユーザーの情報）
    @currentUserEntry=Entry.where(user_id: current_user.id) #Entry`モデルから`user_id`が`current_user.id`と一致するレコードを検索、検索結果を@currentUserEntryに代入
    @userEntry=Entry.where(user_id: @user.id) #指定されたユーザーのIDと一致するレコードを検索、検索結果を@userEntryに代入
    if @user.id == current_user.id #@user`のIDと`current_user`のIDを比較します。もし一致していれば、何もしない
    else #一致しなかった場合
      @currentUserEntry.each do |cu|
        @userEntry.each do |u| #@currentUserEntry`と`@userEntry`の各エントリーを繰り返し処理します。これにより、現在のユーザーと表示するユーザーの参加情報を取得します
          if cu.room_id == u.room_id then #ループの中で、`cu.room_id`と`u.room_id`を比較します。もし一致していれば、`@isRoom`フラグを`true`に設定し、`@roomId`に`cu.room_id`の値を代入します
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom #@isRoom`が`true`であれば、処理は終了です。そうでない場合は、新しい`Room`オブジェクトと`Entry`オブジェクトを作成します
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end
    

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
