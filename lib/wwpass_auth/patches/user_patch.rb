# encoding: utf-8

require_dependency 'user'



module UserPatch
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			has_many :puids, dependent: :delete_all 
		end
	end

	module ClassMethods
		
		def find_by_puid(puid)
			logger.info "UserPatch method find_by_puid"
			if !puid.is_a? String
				puid = puid.to_s
			end

			wwp_user = Puid.find_by_puid(puid)

			if !wwp_user.nil?
				logger.info "PUID found: " + wwp_user.puid + ", for user: " + wwp_user.user.login
				return wwp_user.user
			else
				return nil
			end
		end

	end

	module InstanceMethods
			
	end

end

User.send(:include, UserPatch)
