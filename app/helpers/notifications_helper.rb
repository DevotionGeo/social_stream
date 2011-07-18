module NotificationsHelper
  include SubjectsHelper, ActionView::Helpers::TextHelper  
  
  def decode_notification notification_text, activity
    return if activity.nil?
    notification_text = notification_text.gsub(/\%\{sender\}/, link_to(truncate_name(activity.sender.name), activity.sender.subject))   
    notification_text = notification_text.gsub(/\%\{confirm\}/,link_to(t('notification.confirm'),edit_contact_path(activity.receiver.contact_to!(activity.sender))))
    notification_text = notification_text.gsub(/\%\{look\}/,link_to(t('notification.look'),activity.sender.subject))
    notification_text = notification_text.gsub(/\%\{sender.name\}/,truncate_name(activity.sender.name))
    
    if activity.direct_object.present?
      object = activity.direct_object
      object = object.subject if object.is_a? Actor
      notification_text=notification_text.gsub(/\%\{object\}/,link_to(object.class.to_s.downcase,object))
      notification_text=notification_text.gsub(/\%\{object.name\}/,object.class.to_s.downcase)
      notification_text=notification_text.gsub(/\%\{object.text\}/,link_to(object.text.truncate(100, :separator =>' '), object)) if object.respond_to? :text 
      #notification_text=notification_text.gsub(/\%\{object.image\}/,thumb_for(object)) if SocialStream.activity_forms.include? :document and object.is_a? Document
      
    else
      notification_text=notification_text.gsub(/\%\{object\}/,"nilclass")
      notification_text=notification_text.gsub(/\%\{object.name\}/,"nilclass")
    end

    notification_text
  end
end