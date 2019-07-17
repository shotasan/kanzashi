class CommentsController < ApplicationController
  before_action :set_comment, except: :create

  def create
    @comment = current_user.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.js { render :index }
      else
        format.js { render :error }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:user_id, :review_id, :content)
  end
end
