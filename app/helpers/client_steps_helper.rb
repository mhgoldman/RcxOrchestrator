module ClientStepsHelper
	def client_step_status_for(client_step)
		if client_step.finished?
			"#{client_step.status} / #{client_step.result} (#{client_step.exit_code})"
		else
			"#{client_step.status}"
		end
	end

	def client_step_status_link_for(client_step)
		link_to client_step_status_for(client_step), client_step
	end
end
