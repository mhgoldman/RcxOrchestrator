class FetchClientsJob < ActiveJob::Base
  MAX_DURATION = 10.minutes
  queue_as :frontend_requests

  def perform(user)
  	user.clients.fetch!
  end

  around_perform do |job, block|
  	user = job.arguments.first
  	raise "FetchClients already in progress for #{user}" if user.clients_update_finished_at.nil? && 
      (!user.clients_update_started_at.nil? && user.clients_update_started_at <= MAX_DURATION.ago)

  	user.update(clients_update_started_at: Time.now, clients_update_finished_at: nil)

    begin
    	block.call
    ensure
      user.update(clients_update_finished_at: Time.now)   
    end
  end
end