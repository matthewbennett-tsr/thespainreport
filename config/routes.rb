Rails.application.routes.draw do
  resources :quotes
  resources :organisations
  resources :sources
  get 'entries/world_all'
  get 'entries/world_home'
  get 'entries/world_politics'
  get 'entries/world_economy'
  get 'entries/world_foreign_affairs'
  get 'entries/world_media'
  get 'entries/spain_english'
  get 'entries/spain_all'
  get 'entries/spain_home'
  get 'entries/spain_opinion'
  get 'entries/spain_international'
  get 'entries/spain_national'
  get 'entries/spain_economy'
  get 'entries/spain_other'
  get 'entries/cincodias'
  get 'entries/abc'
  get 'entries/antenatres'
  get 'entries/cope'
  get 'entries/efe'
  get 'entries/elconfidencial'
  get 'entries/elconfidencialdigital'
  get 'entries/eldiario'
  get 'entries/eleconomista'
  get 'entries/elespanol'
  get 'entries/elmundo'
  get 'entries/elpais'
  get 'entries/elperiodico'
  get 'entries/europapress'
  get 'entries/expansion'
  get 'entries/infolibre'
  get 'entries/lasexta'
  get 'entries/larazon'
  get 'entries/lavanguardia'
  get 'entries/libertaddigital'
  get 'entries/ondacero'
  get 'entries/publico'
  get 'entries/ser'
  get 'entries/telecinco'
  get 'entries/tve'
  get 'entries/vozpopuli'
  resources :entries
  resources :feeds do
    member do
      get 'retrieve'
      post 'subscribe'
      post 'unsubscribe'
    end
  end
  mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path
  resources :salesemails
  post 'new_subscription' => 'subscriptions#new_subscription'
  post 'new_spain_report_member' => 'subscriptions#new_spain_report_member'
  resources :subscriptions
  get 'users/confirm'
  get 'users/newerrors'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get 'articles/new_summary' => 'articles#new_summary'
  get 'articles/admin'
  get 'articles/blog'
  get 'articles/editorial'
  get 'articles/in-depth'
  get 'articles/news'
  get 'newsitems/admin'
  get 'stories/admin'
  resources :password_resets
  resources :users do
    member do
      get :confirm_email
    end
  end
  resources :audios
  resources :types
  resources :articles
  resources :articles do
    resources :comments, :only => [:create]
  end
  resources :comments
  resources :categories
  resources :stories
  resources :regions
  resources :newsitems
  resources :newsitems do
    resources :comments, :only => [:create]
  end
  get 'welcome/index'
  get '/:page' => 'pages#show'
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
