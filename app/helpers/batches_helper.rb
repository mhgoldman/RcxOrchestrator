module BatchesHelper
	def batch_client_status_for(batch, client)
		cb = ClientBatch.get(client, batch)
		(cb.over? ? "Finished" : "In Progress") + " (" + 
			cb.invocations_count_by_status.map {|k,v| "#{v} #{k}"}.join(", ") + 
			")"
	end	

	def batch_status_for(batch)
		(batch.over? ? "Finished" : "In Progress")
	end

	def batch_link_for(batch)
		link_to batch.name, batch
	end
end