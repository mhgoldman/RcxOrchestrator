class RemoveClientsUpdateStartedAtAndClientsUpdateFinishedAtFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :clients_update_started_at, :timestamp
  	remove_column :users, :clients_update_finished_at, :timestamp
  end
end
