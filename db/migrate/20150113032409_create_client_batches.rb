class CreateClientBatches < ActiveRecord::Migration
  def change
    create_table :client_batches do |t|
      t.integer :client_id
      t.integer :batch_id

      t.timestamps null: false
    end
  end
end
