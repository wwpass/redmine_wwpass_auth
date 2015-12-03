class WwpassController < ApplicationController
	unloadable
	skip_filter :check_if_login_required

	def get_ticket
		logger.info "Method: get_ticket"
		cert_file = Setting.plugin_wwpass_auth['wwpass_sp_cert']
		key_file = Setting.plugin_wwpass_auth['wwpass_sp_key']
		cert_ca = Setting.plugin_wwpass_auth['wwpass_ca_cert']
		begin
			wwp = WWPass.new(cert_file, key_file, cert_ca)
			ticket = wwp.get_ticket(300)
			ticket_json = {:ticket => ticket, :ttl => 300}
			render :json => ticket_json
		rescue Exception => e
			logger.info e.inspect
			return nil
		end
	end

end