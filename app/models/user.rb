class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :rcx_clients do
  	def fetch!
  		RcxClient.fetch_for_user!(self.proxy_association.owner)
  	end
  end
end
