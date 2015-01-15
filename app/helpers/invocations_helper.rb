module InvocationsHelper
	def invocation_status_for(invocation)
		if invocation.finished?
			"#{invocation.status} / #{invocation.result} (#{invocation.exit_code})"
		else
			"#{invocation.status}"
		end
	end

	def invocation_status_link_for(invocation)
		link_to invocation_status_for(invocation), invocation
	end
end
