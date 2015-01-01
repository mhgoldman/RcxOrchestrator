class CreateRcxClients < ActiveRecord::Migration
  def change
    create_table :rcx_clients do |t|
      t.integer :user_id      
      t.string :display_name
      t.string :agent_endpoint_url
      t.string :type
      t.integer :skytap_vm_id
      t.string :skytap_config_url

      t.timestamps null: false
    end
  end
end
