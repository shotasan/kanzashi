class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = current_user.reviews.build
    if params[:blend]
      3.times { @review.targets.build }
    else
      @review.targets.build
    end
  end

  def edit
    @review = current_user.reviews.find(params[:id])
  end

  def create
    @review = current_user.reviews.build(review_params)

    if @review.save
      redirect_to review_url(@review), notice: '登録に成功しました。'
    else
      render :new
    end
  end

  def update
    @review = current_user.reviews.find(params[:id])

    if @review.update(review_params)
      redirect_to review_path(@review), notice: '編集に成功しました。'
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:original?, :title, :content, :image, :drank_on, :rating, :bitter, :acidity, :rich, :sweet, :aroma,
                                   targets_attributes: %i[id bean_id roasted roasted_on grind amount])
  end
end
