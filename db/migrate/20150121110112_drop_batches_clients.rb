class DropBatchesClients < ActiveRecord::Migration
  def change
  	drop_table :batches_clients
  end
end
