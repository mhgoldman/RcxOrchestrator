class AddCallbackTokenToClientSteps < ActiveRecord::Migration
  def change
    add_column :client_steps, :callback_token, :string
  end
end
