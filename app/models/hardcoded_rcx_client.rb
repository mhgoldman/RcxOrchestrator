class HardcodedRcxClient < RcxClient
	has_display_name "Hardcoded VMs"	

	def up?
		true
	end

	def authorized?
		true
	end
	
	def awaken!
	end
	
	private
	
	def self.fetch_for_user(user)
		[ 
			HardcodedRcxClient.new(display_name: "My Parallels VM", agent_endpoint_url: "http://10.211.55.3:8789/", user: user)
		]
	end	
end