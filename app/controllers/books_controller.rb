class BooksController < ApplicationController
   before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day #現在の時刻を取得し、その日の終わりの時刻を表す変数をtoに格納
    from  = (to - 6.day).at_beginning_of_day #toから6日前の始まりの時刻を表す変数をfromに格納
    @books = Book.all.sort {|a,b| b.favorites.where(created_at: from...to).size <=> a.favorites.where(created_at: from...to).size}
     #Book.allでbookモデルからすべてのデータを取得。
     #取得したデータに関連したfavoritesモデルからcreated_atカラムのfrom...toのレコードを取得し、aとbに代入してどちらがお気に入りの数が多いか比較
     #比較して多い順になれべている
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
    redirect_to books_path
    end
  end
  
  
end
