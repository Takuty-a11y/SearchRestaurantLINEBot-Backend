Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :line do
    namespace :v1 do
      post 'callback' => 'line_bot#callback'
    end
  end
  namespace :api do
    namespace :v1 do
      get 'search' => 'web_search#index'
      get 'largearea' => 'web_search#largearea'
      get 'middlearea' => 'web_search#middlearea'
    end
  end
end
