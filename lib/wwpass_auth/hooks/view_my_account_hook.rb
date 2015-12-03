module WwpassAuth
	module Hooks
		class ViewMyAccountHook < Redmine::Hook::ViewListener

			render_on(:view_my_account, :partial => 'my/account', :layout => false)

			def view_my_account_contextual(context = {})
				#tags = [stylesheet_link_tag("vk", :plugin => "wwpass_auth", :media => "screen")]
				#tags << javascript_include_tag("wwpass_button.js", :plugin => "wwpass_auth")
				tags = [javascript_include_tag("wwpass_button.js", :plugin => "wwpass_auth")]

				#tags << form_tag({:controller => 'bind', :action => 'bind_wwpass'}, {:ticket => ''}, :id => 'wwpass_form')

				return tags.join(' ')
			end

		end
	end
end