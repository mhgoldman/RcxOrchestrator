class AddErrorToClientSteps < ActiveRecord::Migration
  def change
    add_column :client_steps, :error, :string
  end
end
