require 'redmine'

#require_dependency 'rest_client'

=begin
require_dependency 'wwpass_auth/hooks/view_account_login_bottom_hook'
require_dependency 'wwpass_auth/hooks/view_my_account_hook'
require_dependency 'account_controller_patch'
=end


Redmine::Plugin.register :wwpass_auth do
  name 'Wwpass Authentication Plugin'
  author 'WWPass Corporation'
  description 'This plugin adds WWPass authentication into Redmine application'
  version '0.1.0'
  url 'http://example.com/path/to/plugin'
  author_url 'http://wwpass.com/'

  settings :default => {'empty' => true}, :partial => 'settings/wwpass_auth_settings'
end

# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
	require_dependency 'wwpass_auth/hooks/view_account_login_bottom_hook'
	require_dependency 'wwpass_auth/hooks/view_my_account_hook'
	require_dependency 'wwpass_auth/patches/account_controller_patch'
  require_dependency 'wwpass_auth/patches/user_patch'
end
