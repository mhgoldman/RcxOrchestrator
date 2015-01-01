class AddSkytapUsernameAndSkytapApiTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :skytap_username, :string  	
    add_column :users, :skytap_api_token, :string
  end
end
