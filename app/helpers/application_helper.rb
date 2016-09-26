module ApplicationHelper
  def current_user_author?(obj)
    if current_user && obj.respond_to?(:user_id)
      obj.user_id == current_user.id
    else
      false
    end
  end

  def cache_for_user_role(prefix, model)
    cache_unless current_user.try(:admin), [prefix.to_s, user_signed_in?, current_user_author?(model), model] do
      yield
    end
  end
end
