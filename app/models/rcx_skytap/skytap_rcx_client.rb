class RcxSkytap::SkytapRcxClient < RcxClient
	has_display_name "Skytap VMs"	

	def awaken!
		skytap_vm = get_skytap_vm

		case skytap_vm.runstate
		when 'stopped', 'suspended'
			skytap_vm.update('running')
			skytap_vm.save
		when 'running'
			return
		else
			raise "Unknown runstate #{skytap_vm.runstate}"
		end
	end

	private

	def get_skytap_vm
		# Note: we don't store this in an instance variable because the VM statuses change all the time. We always need a fresh copy.

		self.class.set_skytap_credentials_for(user)

		RcxSkytap::Skytap::Vm.find(skytap_vm_id, configuration_url: skytap_config_url) or raise 'Skytap VM does not exist or user is not authorized'
	end

	def self.fetch_for_user(user)
		return [] if user.rcx_skytap_username.blank? || user.rcx_skytap_api_token.blank?
		
		set_skytap_credentials_for(user)

		vms = []

		RcxSkytap::Skytap::Configuration.all.fetch.each do |config|
			vms |= config.vms
		end

		RcxSkytap::Skytap::Project.all.fetch.each do |project|
			project.configurations.each do |config|
				vms |= config.vms
			end
		end

		vms.uniq {|vm| vm.id }.map { |vm| vm.to_skytap_rcx_client_for_user(user) }.compact
	end	

	def self.set_skytap_credentials_for(user)
    RequestStore.store[:skytap_username] = user.rcx_skytap_username
    RequestStore.store[:skytap_api_token] = user.rcx_skytap_api_token		
   end
end