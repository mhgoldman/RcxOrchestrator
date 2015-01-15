class FetchClientsJob < ActiveJob::Base
  queue_as :frontend_requests

  def perform(user)
  	user.clients.fetch!
  end
end