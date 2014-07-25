BmsomRoomsBootstrap::Application.routes.draw do

  #TODO: Remember locale in a cookie
  #TODO: Fix url root

  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

    resources :rooms, except: [:show, :delete]

    resources :users, except: [:show, :delete] do
      resources :reservations, except: [:show, :delete]
    end

    post ':controller(/:action(/:id(.:format)))'
    get ':controller(/:action(/:id(.:format)))'

    root to: 'login#index', :as => :root_with_locale
  end

  get '*path', to: redirect("/#{I18n.locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }

  root to: 'login#index', locale: 'en'

  get '*path' => redirect("/#{I18n.default_locale}", status: 302)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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
