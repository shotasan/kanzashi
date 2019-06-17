class ReviewsController < ApplicationController
  def index
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = current_user.reviews.build

    if params[:blend]
      2.times do
        @review.beans.build
        @review.targets.build
      end
    else
      @bean = Bean.new
      @target = Target.new
    end
  end

  def edit
  end

  def create
    @review = current_user.reviews.build(review_params)
    @target = Target.new(target_params)
    @bean = Bean.new

    @review.transaction do
      @bean = Bean.create!(bean_params)
      @target.bean_id = @bean.id
      @review.targets << @target
    # @targets = target_params.map { |params| @review.targets.build(params) }
    # @beans = Bean.new
    #
    # Review.transaction do
    #   @beans = bean_params.map { |params| Bean.create!(params) }
    #   @review.beans = @beans
    #   @targets.zip(@beans) { |target, bean| target.bean_id = bean.id }
    # binding.pry
      @review.save!
    end
    redirect_to review_url(@review), notice: '登録に成功しました。'
  rescue
    @review.valid?
    render :new
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
  # def bean_params
  #   params.require(:bean).map { |bean| bean.permit(:name, :country, :plantation) }
  # end

  def target_params
    params.require(:target).permit(:roasted, :roasted_on, :grind, :amount)
  end

    # def target_params
  #   params.require(:target).map { |target| target.permit(:roasted, :roasted_on, :grind, :amount) }
  # end
end
