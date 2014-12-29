class SkytapRcxClient < RcxClient
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

	private

	def get_skytap_vm
		Skytap::Vm.find(@skytap_vm_id, configuration_url: @skytap_config_url)
	end
end
