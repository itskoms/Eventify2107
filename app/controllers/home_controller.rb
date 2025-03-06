class HomeController < ApplicationController
  # Ensure the user is authenticated before accessing the index action
  before_action :authenticate_user!, only: [ :index ]

  # Display events organized by the current user and events where the user is a guest
  def index
    # Fetch events organized by the current user
    @organized_events = Event.where(user_id: current_user.id)
    # Fetch events where the current user is a guest (excluding events they organized)
    @guest_events = Event.joins(:guests).where("guests.user_id = ? AND events.user_id != ?", current_user.id, current_user.id).distinct
  end
end
