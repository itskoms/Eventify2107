class SessionsController < ApplicationController
  # Render the user login form
  def new
  end

  # Create a session for the user if email and password are correct
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password"  # Show an error message if authentication fails
      render :new
    end
  end

  # Destroy the user session to log the user out
  def destroy
    session[:user_id] = nil  # Remove user ID from session
    redirect_to user_sessions_path, notice: "Logged out successfully!"  # Redirect to the login page
  end
end
