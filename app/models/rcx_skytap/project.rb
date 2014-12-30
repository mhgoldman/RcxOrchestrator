class RcxSkytap::Project
	include Her::Model

	has_many :configurations, class: RcxSkytap::Configuration
end
