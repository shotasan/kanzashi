class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]

  def index
    @q = Review.ransack(params[:q])
    @reviews = @q.result(district: true).resent
  end

  def show
    @review = Review.find(params[:id])
    @favorite = current_user.favorites.find_by(review_id: @review)
    @comment = @review.comments.build
    @comments = @review.comments
  end

  def new
    @review = current_user.reviews.build
    if params[:blend]
      3.times { @review.targets.build }
    else
      @review.targets.build
    end
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
    params.require(:review).permit(:original?, :title, :content, :image, :drank_on, :rating, :bitter, :acidity, :rich, :sweet, :aroma,
                                   targets_attributes: %i[id bean_id roasted roasted_on grind amount])
  end
end
