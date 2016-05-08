Rails.application.routes.draw do

  devise_for :playlist_editors

  resources :djs, only: [:index, :new, :create]
  devise_for :djs, controllers: { passwords: 'djs/passwords' }

  resources :semesters, shallow: true do
    resources :freeform_shows
    resources :specialty_shows do
      patch 'deal', on: :member
    end
    resources :talk_shows
    get 'based_on/:model_id', action: :new, on: :new
  end

  resources :songs, only: [:find] do
    get :find, on: :collection
  end
  resources :trainees, shallow: true do 
    resources :djs, except: [:index, :new], shallow: true do
      resources :episodes, except: [:show] do
        resources :songs
        resources :sub_requests, only: [:new, :create]
      end
    end
  end
  resources :episodes, only: [] do
    get :on_and_upcoming, on: :collection
  end

  resources :sub_requests, except: [:new, :create]

  resources :signoffs
  resources :signoff_instances, only: [:index, :update] do
    get :public_affairs_logs, on: :collection
  end

  resources :setbreaks, only: [:update, :create, :destroy]

  root 'playlist#index'
  resources :playlist, only: [:index] do
    get :search, on: :collection
    get :archive, on: :collection
  end

  mount ActionCable.server => '/cable'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

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
