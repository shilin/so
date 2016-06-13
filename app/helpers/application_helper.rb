module ApplicationHelper
  def current_user_author?(obj)
    if current_user && obj.respond_to?(:user_id)
      obj.user_id == current_user.id
    else
      false
    end
  end
end
