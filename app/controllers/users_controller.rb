class UsersController < Users::RegistrationsController
  def index
    redirect_to edit_user_registration_url(current_user)
  end

  def show
    @user = User.find(params[:id])
  end
end