class CreateInvocations < ActiveRecord::Migration
  def change
    create_table :invocations do |t|
      t.integer :client_id
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
