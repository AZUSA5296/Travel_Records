class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :baria_user, { only: [:edit, :update, :destroy] }

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "スポットを投稿しました"
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
  end

  def index
    @posts = Post.all
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :date, :image, :content)
  end

  def baria_user
    if current_user.nil? || Spot.find(params[:id]).user.id.to_i != current_user.id
      flash[:alert] = "権限がありません"
      redirect_to top_path
    end
  end

end
