class PushNotification
  
  def self.send_notification(sender,receiver, product, message = "Hi")
    device = receiver.device
    notification = Gcm::Notification.new
    notification.device = device
    notification.collapse_key = "review_monk_says"
    notification.delay_while_idle = true
    notification.data = { :registration_ids => [device.registration_id],
                          :data => { :message_text => "#{message}", :sender => sender.to_json }
                        }
    notification.data.merge!({ :product_name => product.name }) if product.present?
    notification.save

    Gcm::Notification.send_notifications
  end

end