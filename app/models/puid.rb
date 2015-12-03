class Puid < ActiveRecord::Base
  unloadable
  belongs_to :user
  attr_accessible :puid, :user, :description


  def self.user_has_puid?
  	puid = Puid.find_by_user_id(User.current.id)

  	return puid.nil?
  end

end
