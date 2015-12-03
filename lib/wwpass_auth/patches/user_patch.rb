# encoding: utf-8

require_dependency 'user'



module UserPatch
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)

		base.class_eval do
			unloadable
			has_one :puids, dependent: :destroy 
		end
	end

	module ClassMethods
		
		def find_by_puid(puid)
			if !puid.is_a? String
				puid = puid.to_s
			end

			wwp_user = Puid.find_by_puid(puid)

			if !wwp_user.nil?
				user = User.find(wwp_user.user_id)
			else
				user = nil
			end
			
			user

		end

	end

	module InstanceMethods
			
	end

end

User.send(:include, UserPatch)
