class BeansController < ApplicationController
  before_action :set_bean, only: %i[edit update destroy]

  def index
    @beans = Bean.all
    @bean = Bean.new
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

  def edit; end

  def update
    if @bean.update(bean_params)
      redirect_to beans_url, notice: '豆の編集に成功しました。'
    else
      render :edit
    end
  end

  def destroy
    if Bean.destroy_bean_and_related_reviews(@bean)
      redirect_to beans_url, notice: "#{ @bean.name }を削除しました。"
    else
      redirect_to beans_url, notice: '削除に失敗しました。'
    end
  end

  private

  def set_bean
    @bean = current_user.beans.find(params[:id])
  end

  def bean_params
    params.require(:bean).permit(:name, :country, :plantation)
  end
end
