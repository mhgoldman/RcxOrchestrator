class AddClientUpdateTimestamps < ActiveRecord::Migration
  def change
    add_column :users, :clients_update_started_at, :datetime
    add_column :users, :clients_update_finished_at, :datetime
  end
end
