class RcxSkytap::Project
	include Her::Model

	has_many :configurations, class: RcxSkytap::Skytap::Configuration
end
