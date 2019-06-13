class ReviewsController < ApplicationController
  def index
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = current_user.reviews.build
    2.times do
      @review.beans.build
      @review.targets.build
    end
  end

  def edit
  end

  def create
    @review = current_user.reviews.build(review_params)
    @beans = bean_params.map { |params| Bean.create(params) }
    @targets = target_params.map { |params| @review.targets.build(params) }
    @targets.zip(@beans) { |target, bean| target.bean_id = bean.id }

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
    params.require(:review).permit(:original?, :title, :content, :image, :drank_on, :rating, :bitter, :acidity, :rich, :sweet, :aroma)
  end

  def bean_params
    params.require(:bean).map { |bean| bean.permit(:name, :country, :plantation) }
  end

  def target_params
    params.require(:target).map { |target| target.permit(:roasted, :roasted_on, :grind, :amount) }
  end
end
