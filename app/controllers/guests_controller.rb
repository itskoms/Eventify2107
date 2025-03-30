class GuestsController < ApplicationController
  # Ensure the user is authenticated before accessing any actions
  before_action :authenticate_user!
  before_action :set_event, only: [ :index, :create, :update, :destroy ]

  # Display all events where the current user is a guest
  def index
    @events = Event.joins(:GuestList).where(guest_lists: { guest_id: current_user.id })
  end

  # Create a new guest for an event, either by finding or creating the user
  # Create a new guest for an event
  def create
    # Validate required parameters
    if params[:email].blank?
      redirect_to @event, alert: "Failed to create guest: Email can't be blank" and return
    end

    if params[:first_name].blank?
      redirect_to @event, alert: "Failed to create guest: First name can't be blank" and return
    end

    if params[:last_name].blank?
      redirect_to @event, alert: "Failed to create guest: Last name can't be blank" and return
    end

    # Find or create the user
    @user = User.find_or_create_by(email: params[:email]) do |user|
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.password = SecureRandom.hex(8) # Generate a random password
    end

    # Check if the user was successfully created
    unless @user.persisted?
      redirect_to @event, alert: "Failed to create guest: #{user.errors.full_messages.join(', ')}" and return
    end

    # Build the guest record
    guest = @event.guests.build(user: @user, role: params[:role] || "guest", party_size: params[:party_size])

    if guest.save
      redirect_to @event, notice: "Guest successfully created."
    else
      redirect_to @event, alert: "Failed to create guest: #{guest.errors.full_messages.join(', ')}"
    end
  end

  # Update guest information (role, RSVP status, party size)
  def update
    guest = @event.guests.find(params[:id])

    # Attempt to update guest details and redirect with appropriate notice
    if guest.update(guest_params)
      redirect_to @event, notice: "Guest information updated successfully."
    else
      redirect_to @event, alert: "Failed to update guest information: #{guest.errors.full_messages.join(', ')}"
    end
  end

  # Update guest attendence
  def update_attendance
    Rails.logger.debug "Params: #(params.inspect}" # Log the entire params hash
    guest = Guest.find_by(user_id: current_user.id, event_id: params[:event_id])

    if guest.update(rsvp_status: params[:rsvp_status])
      redirect_to root_path, notice: "Your RSVP status has been updated!"
    else
      redirect_to root_path, alert: "Failed to update RSVP status."
    end
  end

  # Remove a guest from an event
  def destroy
    guest = @event.guests.find(params[:id])

    # Attempt to remove the guest and redirect with appropriate notice
    if guest.destroy
      redirect_to @event, notice: "Guest removed successfully."
    else
      redirect_to @event, alert: "Failed to remove guest."
    end
  end

  private

  # Find the event associated with the guest
  def set_event
    @event = Event.find(params[:event_id])
  end

  # Permit only the allowed guest parameters for updates
  def guest_params
    params.require(:guest).permit(:role, :rsvp_status, :party_size)
  end
end
