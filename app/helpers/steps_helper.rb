module StepsHelper
	def step_status_for(step)
		(step.over? ? "Finished" : "In Progress") + " (" + step.invocations_count_by_status.map {|k,v| "#{v} #{k}"}.join(", ") + ")"
	end
end
