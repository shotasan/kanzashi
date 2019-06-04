Rails.application.routes.draw do
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  # ログイン、アカウント編集後、任意のページに推移させるための記述
  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }
  resources :users, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
