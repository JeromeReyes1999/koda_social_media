module ApplicationHelper

  def privacy_toggled_value(group)
    Group.privacies.reject{|k| k == group.privacy}.first.first
  end
end
