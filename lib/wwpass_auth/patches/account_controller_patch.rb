# encoding: utf-8

require_dependency 'wwpass_connection/wwpass-connection'
require_dependency 'account_controller'

module AccountControllerPatch

	def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        alias_method_chain :login, :wwpass
        #alias_method_chain :logout, :wwpass
      end
    end

	module InstanceMethods

		def login_with_wwpass
			logger.info "WWPass Auth login_with_wwpass"
			#logger.info "params[:ticket] = " + params[:ticket]
			#logger.info :ticket
			if params[:ticket]
				cert_file = Setting.plugin_wwpass_auth['wwpass_sp_cert']
				key_file = Setting.plugin_wwpass_auth['wwpass_sp_key']
				cert_ca = Setting.plugin_wwpass_auth['wwpass_ca_cert']

				begin
					wwp = WWPass.new(cert_file, key_file, cert_ca)
					puid = wwp.get_puid(wwp.put_ticket(params[:ticket]))
					wwp_user = Puid.find_by_puid(puid)

					if wwp_user.nil?
						err_msg = "This WWPass key is not bound to any account"
						flash.now[:error] = err_msg
						logger.info err_msg + "[puid = " + puid + "]"
						return
					else
						if !wwp_user.user.active?
							err_msg "This WWPass key is not bound to any account"
							flash.now[:error] = err_msg
							logger.info err_msg + "[puid = " + puid + "]"
							return
						end
						user = wwp_user.user
						user.update_attribute(:last_login_on, Time.now) if user && !user.new_record?
						logger.info user.login + " logged in successfully"
						self.logged_user = user
						redirect_back_or_default home_url#, :referer => true
						#return
					end
				rescue Exception => msg
					flash.now[:error] = 'WWPass authentication error! Please, check your plugin settings or contact administrator.'
					logger.info msg.inspect
					return
				end
			else
				login_without_wwpass
			end
		end
	end
end

AccountController.send(:include, AccountControllerPatch)