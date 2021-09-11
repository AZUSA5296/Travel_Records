class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :baria_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
    # 非公開記事の制限
    if @user != current_user
      @posts = Post.where(status: false, user_id: @user.id)
    end

    # タグで絞り込む
    if params[:tag_name]
      @posts = Post.tagged_with(params[:tag_name])
    end
  end

  def index
    # 自分以外のユーザー一覧を表示
    @users = User.where.not(id: current_user.id).order(id: "DESC") # idの降順
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを更新しました。"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following
    render 'follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'follow'
  end

  def search
    # 自分以外のユーザーを検索
    @users = User.search(params[:keyword]).where.not(id: current_user.id).order(id: "DESC") # idの降順
    @keyword = params[:keyword]
    render "index"
  end

  private

  def user_params
    params.require(:user).permit(:name, :nickname, :email, :birthday, :profile_image, :introduction)
  end

  # 編集、削除の権限を投稿者だけの機能にする
  def baria_user
    if current_user.nil? || User.find(params[:id]).id.to_i != current_user.id
      flash[:alert] = "権限がありません。"
      redirect_to top_path
    end
  end
end
