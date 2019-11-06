class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]
  before_action :reset_image, only: :update

  def index
    @q = Review.ransack(params[:q])
    @reviews = @q.result(district: true).resent.page(params[:page])
  end

  def show
    @review = Review.find(params[:id])
    @favorite = current_user.favorites.find_by(review_id: @review)
    @comment = @review.comments.build
    @comments = @review.comments.order(:created_at)
  end

  def new
    @review = current_user.reviews.build
    @review.targets.build
  end

  def edit; end

  def create
    @review = current_user.reviews.build(review_params)

    if @review.save
      redirect_to review_url(@review), notice: '登録に成功しました。'
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to review_url(@review), notice: '編集に成功しました。'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_url, notice: "#{ @review.title }を削除しました。"
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:title, :content, :item, :image, :drank_on, :rating, :bitter, :acidity, :rich, :sweet, :aroma,
                                   targets_attributes: %i[id bean_id roasted roasted_on grind amount _destroy])
  end

  def reset_image
    if params[:review][:reset_image]
      @review.image.purge
    end
  end
end
