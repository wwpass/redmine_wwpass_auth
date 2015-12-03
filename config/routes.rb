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
  match '/wwpass/bind', :controller => 'bind', :action => 'bind', :via => [:get, :post]

  match '/wwpass/unbind/:id', :to => 'bind#unbind_wwpass', :as => 'unbind_path', :via => [:delete]

  match '/wwpass/ticket', :controller => 'wwpass', :action => 'get_ticket', :via => [:get]
  match '/my/wwpass/manage', :controller => 'bind', :action => 'manage', :via => [:get, :post]
end