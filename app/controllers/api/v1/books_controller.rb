class Api::V1::BooksController < ApplicationController
  # Ensure the user is authenticated for all actions
  before_action :authenticate_user

  # Set the @book instance variable for actions that require a specific book
  before_action :set_book, only: [:show, :update, :destroy]

  # Restrict book management actions to admins only
  before_action :authenticate_admin!, only: [:create, :update, :destroy]

  # GET /api/v1/books
  # Returns a list of all books
  def index
    books = Book.all
    render json: books, status: :ok
  end

  # GET /api/v1/books/:id
  # Returns details of a specific book
  def show
    render json: @book, status: :ok
  end

  # POST /api/v1/books
  # Admin-only: Creates a new book
  def create
    book = Book.new(book_params)
    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/books/:id
  # Admin-only: Updates an existing book
  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/books/:id
  # Admin-only: Deletes a book
  def destroy
    @book.destroy
    head :no_content
  end

  private

  # Finds the book by ID or returns a 404 error
  def set_book
    @book = Book.find_by(id: params[:id])
    return render json: { error: "Book not found" }, status: :not_found unless @book
  end

  # Strong parameters: whitelist only allowed fields for mass assignment
  def book_params
    params.require(:book).permit(:title, :author, :isbn, :genre, :copies_available)
  end
end
