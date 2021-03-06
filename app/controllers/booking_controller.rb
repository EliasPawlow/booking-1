class BookingController < ApplicationController

  def index
    @seat = Seat.all
    @booked_seats = Seat.where(:status => 'booked').order('created_at DESC').collect{|s| [s.number, s.user.name]}
  end

  def create
    user = User.create({name: params[:book][:name] || 'xyz'})
    params[:book][:seat_number].split(',').each do |number|
      seat = Seat.find_by_number(number)
      seat.update_attributes({user_id: user.id, status: 'booked'})
      WebsocketRails['confirm_seat'].trigger(:change_seat_color, seat.number)
    end
  end

end
