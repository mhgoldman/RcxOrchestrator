module BatchCommandsHelper
	def step_status_for(batch_command)
		(batch_command.over? ? "Finished" : "In Progress") + " (" + batch_command.client_batch_commands_count_by_status.map {|k,v| "#{v} #{k}"}.join(", ") + ")"
	end
end
