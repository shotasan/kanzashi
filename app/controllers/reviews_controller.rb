class ReviewsController < ApplicationController
  def index
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = current_user.reviews.build
    @bean = Bean.new
    @target = Target.new
  end

  def edit
  end

  def create
    @review = current_user.reviews.build(review_params)
    @bean = Bean.new(bean_params)
    @target = Target.new(target_params)

    if @review.save && @bean.save
      @target.review_id = @review.id
      @target.bean_id = @bean.id
      if @target.save
        redirect_to review_url(@review), notice: '登録に成功しました。'
      else
        render :new
      end
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
    params.require(:bean).permit(:name, :country, :plantation)
  end

  def target_params
    params.require(:target).permit(:roasted, :roasted_on, :grind, :amount)
  end
end
