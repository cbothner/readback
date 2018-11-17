# frozen_string_literal: true

Rails.application.routes.draw do
  root 'playlists#show'

  devise_for :djs, controllers: { passwords: 'djs/passwords' }
  devise_for :playlist_editors

  resources :concerts, only: %i[index]

  resources :djs, only: %i[index show new edit create update] do
    resources :episodes, only: %w[index]

    resource :settings, module: :djs, only: %i[edit update]

    resources :upcoming_episodes, only: %w[index]
  end

  resources :episodes, only: %i[edit update] do
    resources :songs, only: %i[index create]
    resources :sub_requests, only: %i[new create]
    get :on_and_upcoming, on: :collection
  end

  resources :events, only: %i[index]

  resources :freeform_shows, only: %i[show update destroy]

  resource :playlist, only: %w[show] do
    get :search, on: :collection
    get :archive, on: :collection
  end

  resources :posts, only: %i[show new create]

  resources :semesters, only: %i[index create show edit] do
    resource :clone, module: :semesters, only: %i[new create]

    resources :freeform_shows, only: %i[create]
    resources :specialty_shows, only: %i[create]
    resources :talk_shows, only: %i[create]
  end

  resources :setbreaks, only: %i[update create destroy]

  resources :settings, only: %i[create update]

  resources :signoffs

  resources :signoff_instances, only: %i[index update] do
    get :public_affairs_logs, on: :collection
  end

  resources :songs, only: %i[update destroy] do
    resource :album_artwork, only: %i[show]
  end

  namespace :songs do
    resources :completions, only: %i[index]
  end

  resources :specialty_shows, only: %i[show update destroy] do
    patch 'deal', on: :member
  end

  resources :sub_requests, only: %i[index show update destroy] do
    resources :fulfillments, module: :sub_requests, only: %i[create]
  end

  resources :talk_shows, only: %i[show update destroy]

  resources :tips, only: [:create]

  resources :trainees, only: %i[index show new edit create update] do
    resources :djs, only: %i[create]
  end

  resources :upcoming_episodes, only: %w[index]

  post 'spotify/swap', to: 'spotify#swap'
  post 'spotify/refresh', to: 'spotify#refresh'

  mount ActionCable.server => '/cable'
end
