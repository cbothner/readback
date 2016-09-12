Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  post 'spotify/swap', to: "spotify#swap"
  post 'spotify/refresh', to: "spotify#refresh"

  resources :tips, only: [:create]

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

  post 'spotify/swap', to: "spotify#swap"
  post 'spotify/refresh', to: "spotify#refresh"
  mount ActionCable.server => '/cable'
end
