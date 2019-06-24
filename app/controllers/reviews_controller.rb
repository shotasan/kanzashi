class ReviewsController < ApplicationController
  def index
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
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:original?, :title, :content, :image, :drank_on, :rating, :bitter, :acidity, :rich, :sweet, :aroma,
                                   targets_attributes: %i[bean_id roasted roasted_on grind amount])
  end
end
