class BooksController < ApplicationController
   before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @book_comment = BookComment.new
  end

  def index
    def index
    to = Time.current.at_end_of_day　#現在の日時を取得し、その日の最後の時刻を代入
    from  = (to - 6.day).at_beginning_of_day　#toから6日間の日時を計算し、その日の始まりに時刻を表す。そのため、`from`には6日前の日付の始まりの時刻が代入される
    @books = Book.includes(:favorites).sort_by {|x| x.favorites.where(created_at: from...to).size}.reverse
      #bookオブジェクトからfavoritesモデルのデータを取得。
      #x.favorites.whereでbookオブジェクトに関連しているfavoritesモデルからcreated_atカラムのfrom...to間のレコードを取得し、sizeでどの本が一番お気に入りなのかを判別
      #sort_by.reverseでお気に入りの数が最も多い書籍から順に並べ替えている
    @book1 = Book.all
    @book = Book.new
    end
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
