class AddRcxSkytapUsernameAndRcxSkytapApiTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rcx_skytap_username, :string  	
    add_column :users, :rcx_skytap_api_token, :string
  end
end
