class RenameClientUserIdToClientsCollectionId < ActiveRecord::Migration
  def change
  	rename_column :clients, :user_id, :clients_collection_id
  end
end
