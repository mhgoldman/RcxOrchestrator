class Skytap::Vm
	include Her::Model

	belongs_to :configuration, class: Skytap::Configuration

	collection_path ":configuration_url/vms"
end