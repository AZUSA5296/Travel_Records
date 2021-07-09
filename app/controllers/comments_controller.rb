class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :baria_user, only: [:destroy]

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    comment.save
    redirect_to post_path(post)
  end

  def destroy
    Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def baria_user
    if current_user.nil? || Comment.find(params[:id]).user.id.to_i != current_user.id
      flash[:alert] = "権限がありません"
      redirect_to post_path(@post)
    end
  end

end
