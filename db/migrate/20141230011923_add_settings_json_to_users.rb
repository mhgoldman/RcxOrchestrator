class AddSettingsJsonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings_json, :text
  end
end
