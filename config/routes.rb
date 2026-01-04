Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      post "auth/register", to: "auth#register"
      post "auth/login",    to: "auth#login"

      resources :products, only: %i[index show create update destroy]
    end
  end
end
