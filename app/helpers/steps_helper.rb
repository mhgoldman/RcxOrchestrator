module StepsHelper
	def step_status_for(step)
		(step.finished? ? "Finished" : "In Progress") + " (" + step.step_instances_count_by_status.map {|k,v| "#{v} #{k}"}.join(", ") + ")"
	end
end
