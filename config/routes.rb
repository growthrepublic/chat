Rails.application.routes.draw do
  mount API::Base => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'

  namespace 'chat' do
    namespace 'v1' do
      resources :users, only: [:show]
    end
  end

  if Rails.env.test?
    resources :test_fixtures, only: [:show]
  end
end