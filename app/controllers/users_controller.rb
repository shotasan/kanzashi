class UsersController < Users::RegistrationsController
  def index
    redirect_to edit_user_registration_url(current_user)
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render 'users/show'}
      format.js { render :index }
    end
  end
end