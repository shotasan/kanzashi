class BeansController < ApplicationController
  def index
  end

  def show
  end

  def new
    @bean = Bean.new
  end

  def create
    @bean = current_user.beans.build(bean_params)
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
