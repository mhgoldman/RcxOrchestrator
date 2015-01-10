module BatchesHelper
	def batch_client_status_for(batch, client)
		(batch.over_for_client?(client) ? "Finished" : "In Progress") + " (" + batch.client_client_batch_commands_count_by_status(client).map {|k,v| "#{v} #{k}"}.join(", ") + ")"
	end	

	def batch_status_for(batch)
		(batch.over? ? "Finished" : "In Progress")
	end

	def batch_link_for(batch)
		link_to batch.name, batch
	end
end