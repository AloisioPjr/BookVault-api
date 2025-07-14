class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:destroy]

  # GET /api/v1/reservations
  def index
    reservations = current_user.admin? ? Reservation.all : current_user.reservations
    render json: reservations, status: :ok
  end

  # POST /api/v1/reservations
  def create
    book = Book.find_by(id: reservation_params[:book_id])
    return render json: { error: "Book not found" }, status: :not_found unless book

    if book.copies_available > 0
      return render json: { error: "Book is available. Please borrow instead." }, status: :unprocessable_entity
    end

    if current_user.reservations.exists?(book_id: book.id)
      return render json: { error: "You have already reserved this book." }, status: :unprocessable_entity
    end

    reservation = current_user.reservations.build(book: book, reserved_at: Time.current)
    if reservation.save
      render json: reservation, status: :created
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/reservations/:id
  def destroy
    if current_user.admin? || @reservation.user_id == current_user.id
      @reservation.destroy
      head :no_content
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:book_id)
  end

  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
    return render json: { error: "Reservation not found" }, status: :not_found unless @reservation
  end
end
