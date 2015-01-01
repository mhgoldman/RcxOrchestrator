class RcxSkytap::Skytap::Configuration
	include Her::Model

	has_many :vms, class: RcxSkytap::Skytap::Vm

	#NOTE: Skytap API doesn't link Configurations back to containing Projects, so can't associate from Config back to Project
end