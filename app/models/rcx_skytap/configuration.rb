class RcxSkytap::Configuration
	include Her::Model

	has_many :vms, class: RcxSkytap::Vm

	#NOTE: Skytap API doesn't link Configs back to containing Projects, so can't associate them here.
end