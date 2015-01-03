class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :batches, dependent: :destroy

  has_many :rcx_clients do
  	def fetch!
  		RcxClient.fetch_for_user!(self.proxy_association.owner)
  	end
  end

  def self.rcx_user_attributes
  	User.attribute_names.select {|name| name.start_with?("rcx_")}.map {|name| name.to_sym}
  end
end
