Rails.application.routes.draw do

  namespace "read_only" do
    get '/users_with_around_action', to: "users#index_with_around_action"
    get '/users_with_block', to: "users#index_with_block"
    get '/users_with_proxy', to: "users#index_with_proxy_class"
  end

  namespace "primary" do
    get '/users', to: "users#index"
  end

  put '/users_on_block/:id', to: "users#update_on_readonly_block"
  put '/users_on_mix/:id', to: "users#read_on_block_then_update"
  put '/users_readonly/:id', to: "users#update_with_use_readonly"
end
