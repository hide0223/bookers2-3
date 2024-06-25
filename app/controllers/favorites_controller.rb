class FavoritesController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save
    session[:return_to] = request.referer
    redirect_to session.delete(:return_to)
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    session[:return_to] = request.referer
    redirect_to session.delete(:return_to)
  end
end
