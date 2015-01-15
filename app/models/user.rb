class User < ActiveRecord::Base
  FETCH_CLIENTS_MAX_DURATION = 10.minutes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :batches, dependent: :destroy do
    def started
      self.where(started: true)
    end
  end

  has_many :clients do
    def fetch!
      user = self.proxy_association.owner
      raise "FetchClients already in progress for #{user}" if user.clients_update_finished_at.nil? && 
        (!user.clients_update_started_at.nil? && user.clients_update_started_at <= FETCH_CLIENTS_MAX_DURATION.ago)

      begin
        user.update(clients_update_started_at: Time.now, clients_update_finished_at: nil)
        Client.fetch_for_user!(user)
      ensure
        user.update(clients_update_finished_at: Time.now)   
      end
    end

    def fetching?
      user = self.proxy_association.owner
      user.clients_update_finished_at.nil? && !user.clients_update_started_at.nil?
    end
  end

  def self.rcx_user_attributes
    User.attribute_names.select {|name| name.start_with?("rcx_")}.map {|name| name.to_sym}
  end
end
