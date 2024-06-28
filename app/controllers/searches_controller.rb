class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "user"
      @users = User.looks(params[:search], params[:word])
      render "/searches/search_result"
    else
      @books = Book.looks(params[:search], params[:word])
      render "/searches/search_result"
    end
  end
  
end
