class UsersController < Users::RegistrationsController
  prepend_before_action :authenticate_scope!

  def index
    redirect_to edit_user_registration_url(current_user)
  end

  def show
    @user = User.find(params[:id])
    @user_reviews = @user.reviews.resent.page(params[:page])
    @favorites = @user.fav_reviews.resent.page(params[:page]) if params[:favorite]
    render 'users/show'
  end
end