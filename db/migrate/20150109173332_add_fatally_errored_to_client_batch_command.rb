class AddFatallyErroredToClientBatchCommand < ActiveRecord::Migration
  def change
    add_column :client_batch_commands, :fatally_errored, :boolean, default: false
  end
end
