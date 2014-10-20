Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :trainers
  resources :trainers

  resources :pokemons
  patch '/capture', to: 'pokemons#capture', as: 'capture'
  post '/damage', to: 'pokemons#damage', as: 'damage'
  patch '/heal', to: 'pokemons#heal', as: 'heal'
end
