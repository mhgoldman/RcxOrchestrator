class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :batches, dependent: :destroy do
    def started
      self.where(started: true)
    end
  end

  has_one :clients_collection, dependent: :destroy
  after_create :create_clients_collection
  delegate :clients, to: :clients_collection
  delegate :update_started_at, to: :clients_collection, prefix: :clients
  delegate :update_finished_at, to: :clients_collection, prefix: :clients

  def self.rcx_user_attributes
    User.attribute_names.select {|name| name.start_with?("rcx_")}.map {|name| name.to_sym}
  end
end
