module ErrorMessagesHelper
  def error_messages_for(object, attr=nil)
    msgs=attr ? object.errors[:base] : object.errors.full_messages
    render 'error_messages_for', msgs: msgs
  end

  def error_messages_for_attr(object, attr)
    render 'error_messages_for_attr', object: object, attr: attr
  end
end