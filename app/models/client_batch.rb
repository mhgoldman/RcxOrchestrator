class ClientBatch < ActiveRecord::Base
	belongs_to :client
	belongs_to :batch
	has_many :client_steps
end
