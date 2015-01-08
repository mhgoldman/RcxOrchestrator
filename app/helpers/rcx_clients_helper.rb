module RcxClientsHelper
	def rcx_client_link_for(rcx_client)
		link_to rcx_client.display_name, rcx_client_path(rcx_client)
	end
end
