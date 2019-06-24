class BeansController < ApplicationController
  def index
    @beans = Bean.all
  end

  def show
  end

  def new
    @bean = Bean.new
  end

  def create
    @bean = current_user.beans.build(bean_params)

    if @bean.save
      redirect_to new_review_url, notice: '新しい豆を登録しました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def bean_params
    params.require(:bean).permit(:name, :country, :plantation)
  end
end
