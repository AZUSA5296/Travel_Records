class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    @user = User.find(params[:followed_id])
    Relationship.create(create_params)
    # 通知の作成
    @user.create_notification_follow!(current_user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    relationship = Relationship.find(params[:id])
    relationship.destroy
  end

  private

  def create_params
    params.permit(:followed_id).merge(follower_id: current_user.id)
  end
end
