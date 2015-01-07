class CreateBatchCommands < ActiveRecord::Migration
  def change
    create_table :batch_commands do |t|
      t.integer :batch_id
      t.integer :command_id
      t.integer :index

      t.timestamps null: false
    end
  end
end
