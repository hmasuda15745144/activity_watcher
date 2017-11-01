class SessionsController < ApplicationController
  before_action :set_user, only: [:registration, :confirmation]
  
  def callback
    auth = request.env['omniauth.auth']

    user = User.find_by(provider: auth['provider'], uid: auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    if user.email == ""
      redirect_to user_registration_url
    else
      redirect_to activity_watcher_url
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
  
  def registration
    if @user.nil?
      redirect_to root_path
    end
  end
  
  def confirmation
    params[:user][:confirmed] = false if params[:commit] == "戻る"
    @user.attributes = confirmation_params
    if @user.save(context: :user_registration)
      redirect_to activity_watcher_url
    else
      render action: 'registration'
    end
  end
  
  private
  
  def set_user
    @user = User.find_by(id: session[:user_id])
  end
  
  def confirmation_params
    params.require(:user).permit(
      :email,
      :user_full_name,
      :university_id,
      :slack_user,
      :student_no,
      :confirmed
    )
  end
end
