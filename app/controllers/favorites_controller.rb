class FavoritesController < ApplicationController
  before_action :set_review, only: %i[create destroy]
  # def index
  #   @favorites = FavoriteBean.where(user_id: current_user.id)
  # end

  def create
    @favorite = current_user.favorites.create(review_id: params[:review_id])

    respond_to do |format|
      format.js { render :index }
    end
  end

  def destroy
    current_user.favorites.find(params[:id]).destroy

    respond_to do |format|
      format.js { render :index }
    end
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end
end
