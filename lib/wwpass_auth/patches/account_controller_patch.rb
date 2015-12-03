# encoding: utf-8

require_dependency 'wwpass_connection/wwpass-connection'
require_dependency 'account_controller'

module AccountControllerPatch

=begin
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
		end
	end
=end


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
					user = User.find_by_puid(puid)

					if user.nil?
						flash.now[:error] = "This is no any account with this WWPass Keyset"
						return
					else
						if !user.active?
							flash.now[:error] = "This is no any account with this WWPass Keyset"
							return
						end
						user.update_attribute(:last_login_on, Time.now) if user && !user.new_record?
						self.logged_user = user
						return
					end
				rescue Exception => msg
					flash.now[:error] = 'WWPass authentication error! Please, check your plugin settings or contact administrator.'
					logger.info msg.inspect
					return
				end

=begin
				if try_wwpass_auth(params[:ticket])
					redirect_back_or_default :controller => 'my', :action => 'page'
					return
				else
					flash.now[:error] = "This is no any account with this WWPass Keyset"
					return
				end
=end

			end

			login_without_wwpass
		end

	end

end

AccountController.send(:include, AccountControllerPatch)