class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :rcx_clients do
  	def fetch!
      #TODO this may need to be async
  		RcxClient.fetch_for_user!(self.proxy_association.owner)
  		self.reload
  	end
  end
end
