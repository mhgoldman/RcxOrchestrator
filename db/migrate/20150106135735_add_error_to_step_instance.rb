class AddErrorToStepInstance < ActiveRecord::Migration
  def change
    add_column :step_instances, :error, :string
  end
end
