resources :books do
  member do
    get 'take'
    get 'give'
    get 'load_history'
  end
  collection do
    post '/upload_photo'
    put '/upload_photo'
    delete '/delete_photo'
  end
end


resources :books_settings, only: [:create, :destroy, :index] do
  collection do
    get :autocomplete_for_users
  end
end
