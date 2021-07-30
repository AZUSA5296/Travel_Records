class NotificationsController < ApplicationController

  def index
    #通知一覧
    @notifications = current_user.passive_notifications
    # 未確認通知のみ
    @notifications.where(check: false).each do |notification|
      notification.update_attributes(check: true)
    end
  end

  def destroy_all
    #通知を全て削除
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end

end
