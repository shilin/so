# frozen_string_literal: true
Rails.application.routes.draw do
  get 'subscriptions/create'

  require 'sidekiq/web'

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post 'provide_email', to: 'omniauth_callbacks#provide_email'
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  get 'search', to: 'search#search'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'questions#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  # TODO add concern commentable

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      patch :unvote
    end
  end

  resources :questions do
    resources :subscriptions, defaults: { subscribable: 'questions' }
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :comments, defaults: { commentable: 'questions' }
    resources :subscriptions, defaults: { subscribable: 'questions' }

    resources :answers, concerns: :votable, shallow: true do
      resources :comments, defaults: { commentable: 'answers' }
      patch :set_best, on: :member
    end
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
