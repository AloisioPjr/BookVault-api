class Api::V1::LoansController < ApplicationController
  # Ensure the user is logged in for all actions
  before_action :authenticate_user

  # Load the loan before certain actions
  before_action :set_loan, only: [:update, :return]

  # Only admins can update a loan record
  before_action :authenticate_admin!, only: [:update]

  # GET /api/v1/loans
  # Lists current user's loans, or all loans if admin
  def index
    loans = current_user.admin? ? Loan.all.includes(:book) : current_user.loans.includes(:book)

    # Include only essential book data to avoid excessive nesting
    render json: loans.as_json(include: { book: { only: [:id, :title] } }), status: :ok
  end

  # POST /api/v1/loans
  # Allows a user to borrow a book if available and not already borrowed
  def create
    book = Book.find_by(id: loan_params[:book_id])
    return render json: { error: "Book not found" }, status: :not_found unless book

    if book.copies_available < 1
      return render json: { error: "No copies available. Please reserve the book." }, status: :unprocessable_entity
    end

    if current_user.loans.exists?(book_id: book.id, returned_at: nil)
      return render json: { error: "You already borrowed this book." }, status: :unprocessable_entity
    end

    # Create a new loan and reduce available copies
    loan = current_user.loans.build(book: book, borrowed_at: Time.current)
    if loan.save
      book.decrement!(:copies_available)
      render json: loan, status: :created
    else
      render json: { errors: loan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/loans/:id
  # Admin-only: Update loan details manually
  def update
    if @loan.update(loan_params)
      render json: @loan, status: :ok
    else
      render json: { errors: @loan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/loans/:id/return
  # Marks a book as returned and increases available copies
  def return
    if @loan.returned_at.present?
      return render json: { error: "Book already returned." }, status: :unprocessable_entity
    end

    # Mark loan as returned and restore copy count
    @loan.update(returned_at: Time.current)
    @loan.book.increment!(:copies_available)

    render json: { message: "Book returned successfully." }, status: :ok
  end

  private

  # Finds the loan by ID or returns 404
  def set_loan
    @loan = Loan.find_by(id: params[:id])
    return render json: { error: "Loan not found" }, status: :not_found unless @loan
  end

  # Strong parameters for loan creation/update
  def loan_params
    params.require(:loan).permit(:book_id, :borrowed_at, :returned_at)
  end
end
