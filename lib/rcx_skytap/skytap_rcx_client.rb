class RcxSkytap::SkytapRcxClient < RcxClient
	has_display_name "Skytap VMs"	
	uses_user_setting :skytap_username, :skytap_api_token	

	def initialize(opts={})
		@skytap_vm_id = opts[:skytap_vm_id]
		@skytap_config_url = opts[:skytap_config_url]

		super(opts)
	end

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

	def self.all
		client_list = []

		RcxSkytap::Configuration.all.fetch.each do |config|
			client_list |= config.vms.map { |vm| vm.to_skytap_rcx_client }
		end

		# RcxSkytap::Project.all.fetch.each do |project|
		# 	client_list["From Projects"][project.name] = {}
		# 	project.configurations.each do |config|
		# 		client_list["From Projects"][project.name][config.name] = config.vms.map { |vm| vm.to_skytap_rcx_client }
		# 	end
		# end

		client_list
	end

	private

	def get_skytap_vm
		# Note: we don't store this in an instance variable because the VM statuses change all the time. We always need a fresh copy.
		RcxSkytap::Vm.find(@skytap_vm_id, configuration_url: @skytap_config_url)
	end
end