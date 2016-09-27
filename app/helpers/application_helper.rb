# frozen_string_literal: true
module ApplicationHelper
  def current_user_author?(obj)
    if current_user && obj.respond_to?(:user_id)
      obj.user_id == current_user.id
    else
      false
    end
  end

  def cache_for_user_role(prefix: nil, model:, related_model: nil)
    cache_unless current_user.try(:admin),
                 [
                   prefix,
                   model,
                   user_signed_in?,
                   can?(:manage, model),
                   can?(:manage, related_model)
                 ] do
      yield
    end
  end
end
