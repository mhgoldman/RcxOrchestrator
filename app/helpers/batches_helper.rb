module BatchesHelper
	def batch_rcx_client_status_for(batch, rcx_client)
		(batch.finished_for_rcx_client?(rcx_client) ? "Finished" : "In Progress") + " (" + batch.rcx_client_client_batch_commands_count_by_status(rcx_client).map {|k,v| "#{v} #{k}"}.join(", ") + ")"
	end	

	def batch_status_for(batch)
		(batch.finished? ? "Finished" : "In Progress")
	end	
end