class Skytap::Project
	include Her::Model

	has_many :configurations, class: Skytap::Configuration
end
