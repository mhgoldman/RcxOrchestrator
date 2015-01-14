module StepsHelper
	def step_status_for(step)
		(step.over? ? "Finished" : "In Progress") + " (" + step.client_steps_count_by_status.map {|k,v| "#{v} #{k}"}.join(", ") + ")"
	end
end
