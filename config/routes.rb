# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html


=begin
post '/login/wwpass_login', :to => 'login#wwpass_login'
=end


RedmineApp::Application.routes.draw do
  #match 'login/wwpass', :controller => 'account', :action => 'wwpass'
  #match 'login/wwpass', :to => 'account#wwpass', :as => 'wwpass', :via => [:get, :post]
  match '/bind/wwpass', :controller => 'bind', :action => 'bind_wwpass', :via => [:get, :post]
  #match 'bind/wwpass', :to => 'bind#bind_wwpass', :as => 'bind_wwpass'
  match '/wwpass/bind', :controller => 'bind', :action => 'index', :via => [:get, :post]

  match '/wwpass/unbind', :to => 'bind#unbind_wwpass', :as => 'unbind_path', :via => [:delete]
end