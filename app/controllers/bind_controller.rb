
class BindController < ApplicationController
	unloadable
	before_filter :require_login

	def manage
		@puids = User.current.puids
	end

	def bind_wwpass
		logger.info "Method: bind_wwpass"

		user = User.current
		ticket = params[:ticket]
		descr = params[:puid_desc]

		cert_file = Setting.plugin_wwpass_auth['wwpass_sp_cert']
		key_file = Setting.plugin_wwpass_auth['wwpass_sp_key']
		cert_ca = Setting.plugin_wwpass_auth['wwpass_ca_cert']

		begin
			wwp = WWPass.new(cert_file, key_file, cert_ca)
			ticket = wwp.put_ticket(ticket)
			puid = wwp.get_puid(ticket)

			if !Puid.find_by_puid(puid)
				User.current.puids.create :puid => puid,
							:user => user,
							:description => descr.nil? || descr.empty? ? 'Empty description' : descr
				redirect_to :controller => 'bind', :action => 'manage'
			else
				flash.now[:error] = "This WWPass Keyset is already bind to another account"
				render 'bind'
			end
		rescue Exception => e
			flash.now[:error] = "WWPass authentication error! Please, check your plugin settings or contact administrator."
			logger.info e.inspect
			render 'bind'
		end
	end

	def unbind_wwpass
		puid_id = params[:id]
		puid = Puid.find(puid_id)
		User.current.puids.destroy(puid)
		redirect_to :controller => 'bind', :action => 'manage'
	end

end