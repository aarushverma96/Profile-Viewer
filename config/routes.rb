Rails.application.routes.draw do
  resources :companies
  resources :users

  put 'user/login' => 'users#login' 
  get 'user/profile' => 'users#show1'

  put 'user/:user_id/company/:company_id' => 'companies#view_company'

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end


