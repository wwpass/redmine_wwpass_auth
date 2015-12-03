module WwpassAuth
	module Hooks
		class ViewAccountLoginBottomHook < Redmine::Hook::ViewListener
			render_on(:view_account_login_bottom, :partial => 'account/login', :layout => false)

			def view_account_login_top(context={})
				tags = [stylesheet_link_tag("vk", :plugin => "wwpass_auth", :media => "screen")]
				tags << javascript_include_tag("wwpass_button.js", :plugin => "wwpass_auth")

				return tags.join(' ')
			end

		end
	end
end