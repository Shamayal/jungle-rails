class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    # Create a new user -> Bcrypt takes in password & confirmation and returns password digest
    @user = User.new(user_params)
  
    if @user.save
      # Create a session with the users' Id
      session[:user_id] = @user.id
      puts "Registration: #{session[:user_id]}"
      # Redirect to the main index of the site.
      redirect_to '/', notice: "Successfully Registered!"
    else
      # flash[:error] = 'An error occured!'
      # If login wasn't successful redirect them to registration again.
      render :new
    end  
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

end