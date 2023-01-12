Rails.application.routes.draw do



#管理者用
#URL/admin/sign_in

  devise_for :admins,skip: [:registraions, :passwords],controllers:{
    sessions: "admin/sessions"
  }

  namespace :admin do
  	get '/search'=>'search#search'
    resources :customers,only: [:index,:show,:edit,:update]
  	resources :items,only: [:index,:new,:create,:show,:edit,:update,]
  	resources :genres,only: [:index,:create,:edit,:update, :show]
  	resources :orders,only: [:index,:show,:update] do
  	  member do
        get :current_index
        resource :order_details,only: [:update]
      end
      collection do
        get :today_order_index
      end
    end
  end

#顧客用
#URL/customers/sign_in

  devise_for :customers,skip: [:passwords],controllers:{
    registrations: "public/registraions",
    sessions: 'public/sessions'
  }

   get 'about' => 'public/homes#about'
  root 'public/homes#top'
  get '/customers/contact' => 'public/customers#contact'

  scope module: :public do
    resources :items,only: [:index,:show]
    get 'search' => 'items#search'
    # deviseと衝突してしまうので、オリジナルに変更
    get 'edit/customers' => 'customers#edit'
    patch 'update/customers' => 'customers#update'

  	resource :customers,only: [:edit,:update,:show] do
  		collection do
  	     get 'quit'
  	     patch 'out'
  	  end
  	end

      resources :cart_items,only: [:index,:update,:create,:destroy] do
        collection do
          delete '/' => 'cart_items#all_destroy'
        end
      end

      resources :orders,only: [:new,:index,:show,:create] do
        collection do
          post 'confirm'
          get 'thanx'
        end
      end

      resources :addresses,only: [:index,:create,:edit,:update,:destroy]
    end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
