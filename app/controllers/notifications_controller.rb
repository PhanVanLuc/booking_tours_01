class NotificationsController < ApplicationController
  def read
    notification = Notification.find(params[:notification_id])
    notification.read_at = Time.zone.now
    notification.save!
    render json: { read: true }
  end
end