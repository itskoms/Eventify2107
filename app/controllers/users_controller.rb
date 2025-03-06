class UsersController < ApplicationController
    # Initialize a new user for the signup form
    def new
        @user = User.new
    end

    # Create a new user with the provided parameters
    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id 
            redirect_to root_path, notice: "Account created successfully."  # Redirect to homepage after successful signup
        else
            render :new  # Re-render the signup form if saving failed
        end
    end

    private

    # Permit only the necessary user parameters for security
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
