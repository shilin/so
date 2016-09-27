module ApplicationHelper
  def current_user_author?(obj)
    if current_user && obj.respond_to?(:user_id)
      obj.user_id == current_user.id
    else
      false
    end
  end

  def cache_for_user_role(params_hash)
    cache_unless current_user.try(:admin),
                 [
                   params_hash[:prefix],
                   params_hash[:model],
                   user_signed_in?,
                   current_user_author?(params_hash[:related_model]),
                   current_user_author?(params_hash[:model])
                 ] do
      yield
    end
  end
end
