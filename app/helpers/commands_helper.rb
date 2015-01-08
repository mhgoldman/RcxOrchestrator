module CommandsHelper
	def command_link_for(command)
		link_to command.name, command
	end
end
