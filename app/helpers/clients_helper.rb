module ClientsHelper
	def client_link_for(client)
		link_to client.display_name, client_path(client)
	end
end
