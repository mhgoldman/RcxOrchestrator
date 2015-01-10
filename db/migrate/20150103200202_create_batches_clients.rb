class CreateBatchesClients < ActiveRecord::Migration
  def change
    create_table :batches_clients, id: false do |t|
			t.belongs_to :batch, index: true
			t.belongs_to :client, index: true
    end
  end
end
