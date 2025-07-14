class Api::V1::BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :update, :destroy]
  before_action :authenticate_admin!, only: [:create, :update, :destroy]

  # GET /api/v1/books
  def index
    books = Book.all
    render json: books, status: :ok
  end

  # GET /api/v1/books/:id
  def show
    render json: @book, status: :ok
  end

  # POST /api/v1/books
  def create
    book = Book.new(book_params)
    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/books/:id
  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/books/:id
  def destroy
    @book.destroy
    head :no_content
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
    return render json: { error: "Book not found" }, status: :not_found unless @book
  end

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :genre, :copies_available)
  end
end
