module NotificationsHelper

  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_item = link_to 'あなたの投稿', user_path(notification), style:"font-weight: bold;"
    @visiter_comment = notification.comment_id
    case notification.kind
      when "follow" then
        tag.a(notification.visiter.nickname, href:user_path(@visiter), style:"font-weight: bold;")+"があなたをフォローしました"
      when "favorite" then
        tag.a(notification.visiter.nickname, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:post_path(notification.post_id), style:"font-weight: bold;")+"にいいねしました"
      when "comment" then
        @comment = Comment.find_by(id: @visiter_comment)&.content
        tag.a(@visiter.nickname, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:post_path(notification.post_id), style:"font-weight: bold;")+"にコメントしました"
    end
  end

  def uncheck_notifications
    @notifications = current_user.passive_notifications.where(check: false)
  end

end
