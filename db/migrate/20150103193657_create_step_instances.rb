class CreateStepInstances < ActiveRecord::Migration
  def change
    create_table :step_instances do |t|
      t.integer :rcx_client_id
      t.integer :step_id
      t.string :client_guid
      t.text :standard_output
      t.text :standard_error
      t.boolean :has_exited
      t.integer :exit_code

      t.timestamps null: false
    end
  end
end
