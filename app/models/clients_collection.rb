class ClientsCollection < ActiveRecord::Base

  FETCH_CLIENTS_MAX_DURATION = 10.minutes

	belongs_to :user

	has_many :clients do
	  def fetch!
	  	clients_collection = self.proxy_association.owner

	    raise "FetchClients already in progress for #{user}" if clients_collection.update_finished_at.nil? && 
	      (!clients_collection.update_started_at.nil? && clients_collection.update_started_at <= FETCH_CLIENTS_MAX_DURATION.ago)

	    begin
	      clients_collection.update(update_started_at: Time.now, update_finished_at: nil)
	      Client.fetch_for_user!(clients_collection.user)
	    ensure
	      clients_collection.update(update_finished_at: Time.now)   
	    end
	  end

	  def fetching?
	  	clients_collection = self.proxy_association.owner
	    clients_collection.update_finished_at.nil? && !clients_collection.update_started_at.nil?
	  end
	 end
end