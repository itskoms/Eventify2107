class EventsController < ApplicationController
  # Ensures that the user is authenticated before accessing any actions
  before_action :authenticate_user!
  # Sets the event for the show, edit, update, destroy, and delete_guest actions
  before_action :set_event, only: [ :show, :edit, :update, :destroy, :delete_guest ]

  # Displays all events organized by the current user and events the user is a guest of
  def index
    @organized_events = Event.where(user_id: current_user.id)
    @guest_events = Event.joins(:guests).where("guests.user_id = ? AND events.user_id != ?", current_user.id, current_user.id).distinct
    @events = @organized_events + @guest_events
  end

  # Displays the details of a specific event
  def show
    @event = Event.find(params[:id])  # Fetch the event by its ID
    @user = current_user
    @guests = @event.guests
    @users = []
    # Iterate over the guests to gather the associated users
    @guests.each do |guest|
      tuser = User.find(guest.user_id)
      @users << tuser if tuser
    end
    @guests.zip @users  # Zip the guests and their associated users together
  end

  # Initializes a new event and its associated guests
  def new
    @event = Event.new
    @guests = @event.guests
  end

  # Creates a new event with the provided parameters
  def create
    @event = Event.new(event_params)
    @event.user = current_user

    # Parse the start and end times for the event
    @event.start_time = parse_date_and_time(params[:event][:start_date], params[:event][:start_hour], params[:event][:start_minute], params[:event][:start_period])
    @event.end_time = parse_date_and_time(params[:event][:end_date], params[:event][:end_hour], params[:event][:end_minute], params[:event][:end_period])

    if @event.save  # Attempt to save the event to the database
      Rails.logger.info "Event created successfully! ID: #{@event.id}"
      # Automatically make the event creator an admin guest for the event
      @event.guests.create!(user: current_user, role: "admin", rsvp_status: "accepted")
      redirect_to @event, notice: "Event was successfully created."
    else
      Rails.logger.error "Failed to create event. Errors: #{@event.errors.full_messages.join(", ")}"
      flash.now[:alert] = "Failed to create event: #{@event.errors.full_messages.join(", ")}"
      render :new
    end
  end

  # Edits an existing event
  def edit
    @event = Event.find(params[:id])  # Fetch the event by its ID
    @user = current_user
    @guests = @event.guests
    @users = []
    # Iterate over the guests to gather the associated users
    @guests.each do |guest|
      tuser = User.find(guest.user_id)
      @users << tuser if tuser  # Add the user to the list if found
    end
    @guests.zip @users
  end

  # Updates an existing event with new information
  def update
    # Parse the new start and end times for the event
    @event.start_time = parse_date_and_time(params[:event][:start_date], params[:event][:start_hour], params[:event][:start_minute], params[:event][:start_period])
    @event.end_time = parse_date_and_time(params[:event][:end_date], params[:event][:end_hour], params[:event][:end_minute], params[:event][:end_period])

    if @event.update(event_params)  # Attempt to update the event with the provided parameters
      redirect_to @event, notice: "Event was successfully updated."
    else
      # Set the variables needed by the edit template
      @user = current_user
      @guests = @event.guests
      @users = []
      # Iterate over the guests to gather the associated users
      @guests.each do |guest|
        tuser = User.find(guest.user_id)
        @users << tuser if tuser  # Add the user to the list if found
      end

      render :edit  # Render the edit form again if there are errors
    end
  end

  # Deletes an event from the database
  def destroy
    @event.destroy!  # Attempt to destroy the event
    redirect_to events_path, notice: "Event was successfully deleted."  # Redirect to the events index page if successful
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to events_path, alert: "Event could not be deleted: " + e.message
  end

  # Adds a new guest to an event or updates an existing guest's information
  def add_guest
    @event = Event.find(params[:id])  # Find the event by ID
    @user = User.find_or_create_by(email: params[:email]) do |user|
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.password = user.first_name + user.last_name
    end

    # Find or initialize the guest record for the user and event
    guest = @event.guests.find_or_initialize_by(user: @user)
    guest.role ||= "guest"
    guest.party_size = params[:party_size]

    if guest.save  # Attempt to save the guest record
      redirect_to edit_event_path(@event), notice: "Guest was successfully added."
    else
      redirect_to @event, alert: "Failed to add guest: #{guest.errors.full_messages.join(', ')}"
    end
  end

  # Removes a guest from an event
  def delete_guest
    @guest = @event.guests.find(params[:guest_id])  # Find the guest by ID

    if @guest.destroy  # Attempt to destroy the guest
      flash[:notice] = "Guest successfully removed."
    else
      flash[:alert] = "Failed to remove guest."
    end

    redirect_to edit_event_path(@event)
  end

  private

  # Finds and sets the event based on the ID from the params
  def set_event
    @event = Event.find(params[:id])
  end

  # Defines the allowed parameters for the event
  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :location, :description)
  end

  # Helper method to parse and format the date and time
  def parse_date_and_time(date, hour, minute, period)
    time_string = "#{date} #{hour}:#{minute} #{period}"
    Time.zone.parse(time_string)
  end
end
