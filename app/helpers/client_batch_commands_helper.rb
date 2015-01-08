module ClientBatchCommandsHelper
	def client_batch_command_status_for(client_batch_command)
		if client_batch_command.finished?
			"#{client_batch_command.status} / #{client_batch_command.result} (#{client_batch_command.exit_code})"
		else
			"#{client_batch_command.status}"
		end
	end

	def client_batch_command_status_link_for(client_batch_command)
		link_to client_batch_command_status_for(client_batch_command), client_batch_command
	end
end
