class RcxSkytap::SkytapRcxClient < RcxClient
	has_display_name "Skytap VMs"	

	def up?
		skytap_vm = get_skytap_vm

		skytap_vm.runstate == 'running'
	end

	def authorized?
		!get_skytap_vm.nil?
	end
	
	def awaken!
		skytap_vm = get_skytap_vm

		case skytap_vm.runstate
		when 'stopped', 'suspended'
			skytap_vm.runstate = 'running'
			skytap_vm.save
		when 'running'
			return
		else
			raise "Cannot awaken in runstate #{skytap_vm.runstate}"
		end
	end

	private

	def get_skytap_vm
		# Note: we don't store this in an instance variable because the VM statuses change all the time. We always need a fresh copy.
		RcxSkytap::Skytap::Vm.find(@skytap_vm_id, configuration_url: @skytap_config_url)
	end

	def self.fetch_for_user(user)
		return [] if user.rcx_skytap_username.blank? || user.rcx_skytap_api_token.blank?
		
		# This is the only way I can figure out how to get the credentials into Her for basic auth
    RequestStore.store[:skytap_username] = user.rcx_skytap_username
    RequestStore.store[:skytap_api_token] = user.rcx_skytap_api_token

		client_list = []

		RcxSkytap::Skytap::Configuration.all.fetch.each do |config|
			client_list |= config.vms.map { |vm| vm.to_skytap_rcx_client_for_user(user) }
		end

		RcxSkytap::Skytap::Project.all.fetch.each do |project|
			project.configurations.each do |config|
				client_list |= config.vms.map { |vm| vm.to_skytap_rcx_client_for_user(user) }
			end
		end

		client_list
	end	
end