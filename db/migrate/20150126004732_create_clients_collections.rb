class CreateClientsCollections < ActiveRecord::Migration
  def change
    create_table :clients_collections do |t|
    	t.integer :user_id
      t.timestamp :update_started_at
      t.timestamp :update_finished_at

      t.timestamps null: false
    end
  end
end
