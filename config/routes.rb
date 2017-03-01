Rails.application.routes.draw do

  resources :accounts, only: [:new, :create, :edit, :update, :show] do
    resources :transactions do
      collection do
        get "sales"
        get "purchases"
        get "invoice"
        get "purchase"
        get "payment"
        get "payment_purchase"
        post  "payment_receive"
      end
      member do
        get "preview"
      end
    end
    resources :products
    resources :users do
      member do
        patch :lock
        patch :unlock
      end
    end
    resources :employees
    resources :suppliers do
      get "transactions", on: :member
    end
    resources :customers do
      get "transactions", on: :member
    end
  end

  as :user do
    get "signup", to: "registrations#new", as: "signup"
    post "signup", to: "registrations#create"
    get "signin", to: "sessions#new", as: "signin"
    post "signin", to: "sessions#create"
    delete "signout", to: "sessions#destroy", as: "signout"
  end

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

  root "home#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
