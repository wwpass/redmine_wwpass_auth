class Wwpass < ActiveRecord::Base

	def self.get_wwp_sp_name
		logger.info "Method: get_ticket"
		cert_file = Setting.plugin_wwpass_auth['wwpass_sp_cert']
		key_file = Setting.plugin_wwpass_auth['wwpass_sp_key']
		cert_ca = Setting.plugin_wwpass_auth['wwpass_ca_cert']
		begin
			wwp = WWPass.new(cert_file, key_file, cert_ca)
			sp_name = wwp.get_name
			return sp_name
		rescue Exception => e
			flash.now[:error] = "WWPass authentication error! Please, check your plugin settings or contact administrator."
			logger.info e.inspect
			return
		end
	end

end