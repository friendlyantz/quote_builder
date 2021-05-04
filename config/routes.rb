# frozen_string_literal: true

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: redirect('/quotes') #FIXME perhaps 'quotes#index' without redirect can be a better solution 

  resources :quotes do
    resources :products, controller: 'quote_products', only: [:new, :create, :destroy] #FIXME poor naming. 
  end
end
