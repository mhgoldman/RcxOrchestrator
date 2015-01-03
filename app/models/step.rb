class Step < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :step_instances, dependent: :destroy

	validates :index, presence: true
end
