class CreateBatchesRcxClients < ActiveRecord::Migration
  def change
    create_table :batches_rcx_clients, id: false do |t|
			t.belongs_to :batch, index: true
			t.belongs_to :rcx_client, index: true
    end
  end
end
