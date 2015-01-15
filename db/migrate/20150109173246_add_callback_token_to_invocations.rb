class AddCallbackTokenToInvocations < ActiveRecord::Migration
  def change
    add_column :invocations, :callback_token, :string
  end
end
