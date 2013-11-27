def document_submission_resources(name)
  resources name do
    member do
      post 'submit'
      post 'accept'
      post 'return'
    end
  end
end

FourthYearProjectSystem::Application.routes.draw do
  devise_for :users, controllers: { :registrations => "users/registrations" }

  root 'tasks#index'

  resources :projects do
    resources :users, only: [:index] do
      post 'add'
      post 'remove'
    end
  end

  document_submission_resources :proposals
  document_submission_resources :progress_reports
  document_submission_resources :final_reports

  resources :oral_presentation_forms do
    member do
      post 'submit'
      post 'accept'
    end
  end

  resources :tasks

  resources :supervisors

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
