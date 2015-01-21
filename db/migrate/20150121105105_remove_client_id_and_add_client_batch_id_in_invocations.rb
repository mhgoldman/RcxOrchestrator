class RemoveClientIdAndAddClientBatchIdInInvocations < ActiveRecord::Migration
  def change
    add_column :invocations, :client_batch_id, :integer
    remove_column :invocations, :client_id
  end
end
