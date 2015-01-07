class CreateClientBatchCommands < ActiveRecord::Migration
  def change
    create_table :client_batch_commands do |t|
      t.integer :rcx_client_id
      t.integer :batch_command_id
      t.string :client_guid
      t.text :standard_output
      t.text :standard_error
      t.boolean :has_exited
      t.integer :exit_code

      t.timestamps null: false
    end
  end
end
