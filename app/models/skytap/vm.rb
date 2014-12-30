class Skytap::Vm
	include Her::Model

	belongs_to :configuration, class: Skytap::Configuration

	collection_path ":configuration_url/vms"

	def to_skytap_rcx_client
		SkytapRcxClient.new( { display_name: name, skytap_vm_id: id, skytap_config_url: configuration_url, 
			agent_endpoint_url: "http://#{interfaces.first['ip']}:8789/" } )
	end		
end