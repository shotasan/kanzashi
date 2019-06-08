Rails.application.routes.draw do
  # ログイン、アカウント編集後、任意のページに推移させるための記述
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    root to: 'devise/sessions#new'
    resources :users, only: %i[index show]
  end

  resources :reviews
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
