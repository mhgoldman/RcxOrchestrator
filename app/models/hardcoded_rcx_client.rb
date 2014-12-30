class HardcodedRcxClient < RcxClient
	has_display_name "Hardcoded VMs"	

	def up?
		true
	end

	def authorized?
		true
	end
	
	def self.all
		client_list = [ 
			HardcodedRcxClient.new(display_name: "My Parallels VM", agent_endpoint_url: "http://10.211.55.3:8789/")
		]

		client_list
	end	
end