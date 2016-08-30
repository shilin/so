class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_subscribable, only: [:create, :destroy]
  before_action :get_subscription, only: :destroy

  authorize_resource

  respond_to :js, :json

  def create
    respond_with(@subscription = @subscribable.subscriptions.create!(user: current_user))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def subscription_params
    params.require(:subscription).permit(:id)
  end

  def get_subscribable
    @subscribable = model_klass.find(model_id)
  end

  def get_subscription
    raise CanCan::AccessDenied unless @subscription = @subscribable.subscriptions.find_by(user: current_user)
  end

  def model_klass
    params[:subscribable].classify.constantize
  end

  def model_id
    params["#{model_klass.name.downcase}_id"]
  end
end
