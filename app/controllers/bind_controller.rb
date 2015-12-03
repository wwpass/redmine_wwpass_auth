
class BindController < ApplicationController
	unloadable

	def bind_wwpass
		logger.info "Method: bind_wwpass"

		user = User.current
		ticket = params[:ticket]

		cert_file = Setting.plugin_wwpass_auth['wwpass_sp_cert']
		key_file = Setting.plugin_wwpass_auth['wwpass_sp_key']
		cert_ca = Setting.plugin_wwpass_auth['wwpass_ca_cert']

		begin
			wwp = WWPass.new(cert_file, key_file, cert_ca)
			ticket = wwp.put_ticket(ticket)
			puid = wwp.get_puid(ticket)

			if !User.find_by_puid(puid)
				Puid.create :puid => puid,
							:user_id => user.id
			else
				flash.now[:error] = "This WWPass Keyset is already bind to another account"
			end
		rescue Exception => e
			flash.now[:error] = "WWPass authentication error! Please, check your plugin settings or contact administrator."
			return
		end
		
	end


	def unbind_wwpass
		@puid = Puid.find_by_user_id(User.current.id)
		@puid.destroy

		redirect_to :controller => 'my', :action => 'account'
	end

end