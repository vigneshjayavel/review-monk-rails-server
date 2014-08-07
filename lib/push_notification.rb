class PushNotification
  
  def self.send_notification(device, message = "Hi")
    notification = Gcm::Notification.new
    notification.device = device
    notification.collapse_key = "review_monk_says"
    notification.delay_while_idle = true
    notification.data = { :registration_ids => [device.registration_id],
                          :data => { :message_text => "#{message}, -- #{Time.now}" }
                        }
    notification.save

    Gcm::Notification.send_notifications
  end

end