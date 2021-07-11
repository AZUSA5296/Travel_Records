class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :baria_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      flash.now[:notice] = "コメントを送信しました"
    else
      render :error  #render先にjsファイルを指定
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash.now[:notice] = "コメントを削除しました"
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
