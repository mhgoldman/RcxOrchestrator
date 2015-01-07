class AddErrorToClientBatchCommands < ActiveRecord::Migration
  def change
    add_column :client_batch_commands, :error, :string
  end
end
