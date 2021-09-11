class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :baria_user, only: [:destroy]
  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = @post.id
    @comment_post = @comment.post
    if @comment.save
      @comment_post.create_notification_comment!(current_user, @comment.id)
    else
      render:error # render先にjsファイルを指定
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def baria_user
    if current_user.nil? || Comment.find(params[:id]).user.id.to_i != current_user.id
      flash[:alert] = "権限がありません。"
      redirect_to post_path(@post)
    end
  end
end
