ImGoing::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => 'registrations' }

  devise_scope :user do
    get "signin", :to => "devise/sessions#new"
    get "signup", :to => "devise/registrations#new"
    get "signout", :to => "devise/sessions#destroy"
  end

  root :to => redirect("/nyc")
  match "nyc" => "listings#nyc_feed"
  match "friends" => "listings#friends_feed"
  match "users/:user_id/follow" => "users#follow"
  match "users/:user_id/unfollow" => "users#follow"
  match "share/twitter" => "listings#share"
  match "share/facebook" => "listings#share"
  resources :venues
  resources :listings
  resources :users
  resources :intentions
  resources :comments
  match ":username/find_friends" => "users#find_friends"
  match ":username/find_facebook_friends" => "users#facebook_friends"
  match ":username/find_twitter_friends" => "users#twitter_friends"
  match ":username/show" => "users#show"
  match ":username" => "listings#user"
  
  # resources :listings
  # resources :intentions
  # 
  # root :to => "listings#city_feed"
  # match "listings/new" => "listings#new"
  # match "intentions/new" => "intentions#new"
  # match "feed" => "listings#friend_feed"
  # match "user/:user_id/listing" => "listings#user"
  # match "user/edit" => "users#edit"
  # match "user/update" => "users#update"
  # match "user/facebook_friends" => "users#facebook_friends"
  # match "friends/facebook" => "users#facebook_friends"
  # 
  # match "listing/:listing_id" => "listings#show"
  # match "listing/:listing_id/edit" => "listings#edit"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
