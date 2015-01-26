class RcxSkytap::Skytap::Vm
	include Her::Model

	belongs_to :configuration, class: RcxSkytap::Skytap::Configuration

	collection_path ":configuration_url/vms"

	def to_skytap_client_for_user(user)
		begin
			pub_service = self.interfaces.first['services'].select {|s| s['internal_port'] == 8789}.first
			agent_endpoint_url = "http://#{pub_service['external_ip']}:#{pub_service['external_port'].to_s}/"
		rescue
			return nil #no published service, no rcx client
		end

		RcxSkytap::SkytapClient.new( { display_name: "#{configuration.name}\\#{name}", clients_collection: user.clients_collection, 
			skytap_vm_id: id,	skytap_config_url: configuration_url, agent_endpoint_url: agent_endpoint_url } )
	end		
end