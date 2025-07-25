class Api::V1::ReservationsController < ApplicationController
  # Require authentication for all reservation actions
  before_action :authenticate_user

  # Load a reservation before attempting to delete it
  before_action :set_reservation, only: [:destroy]

  # GET /api/v1/reservations
  # Returns all reservations (for admins) or just the current user's
  def index
    reservations = current_user.admin? ? Reservation.all : current_user.reservations

    # Return reservations with basic book info
    render json: reservations.as_json(include: { book: { only: [:id, :title] } }), status: :ok
  end

  # POST /api/v1/reservations
  # Allows a user to reserve a book that is currently unavailable
  def create
    book = Book.find_by(id: reservation_params[:book_id])
    return render json: { error: "Book not found" }, status: :not_found unless book

    # Prevent reservation if the book is currently available to borrow
    if book.copies_available > 0
      return render json: { error: "Book is available. Please borrow instead." }, status: :unprocessable_entity
    end

    # Prevent duplicate reservations for the same book by the same user
    if current_user.reservations.exists?(book_id: book.id)
      return render json: { error: "You have already reserved this book." }, status: :unprocessable_entity
    end

    # Create a new reservation
    reservation = current_user.reservations.build(book: book, reserved_at: Time.current)

    if reservation.save
      render json: reservation, status: :created
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/reservations/:id
  # Allows users to cancel their own reservation, or admins to cancel any
  def destroy
    if current_user.admin? || @reservation.user_id == current_user.id
      @reservation.destroy
      head :no_content
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  private

  # Strong parameter filtering
  def reservation_params
    params.require(:reservation).permit(:book_id)
  end

  # Finds the reservation or returns a 404 error
  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
    return render json: { error: "Reservation not found" }, status: :not_found unless @reservation
  end
end
