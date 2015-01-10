class HardcodedClient < Client
	has_display_name "Hardcoded VMs"	
	
	def awaken!
	end
	
	private
	
	def self.fetch_for_user(user)
		[ 
			HardcodedClient.new(display_name: "My Parallels VM", agent_endpoint_url: "http://10.211.55.3:8789/", user: user)
		]
	end	
end