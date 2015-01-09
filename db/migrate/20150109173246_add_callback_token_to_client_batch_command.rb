class AddCallbackTokenToClientBatchCommand < ActiveRecord::Migration
  def change
    add_column :client_batch_commands, :callback_token, :string
  end
end
