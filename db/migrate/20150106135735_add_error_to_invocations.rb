class AddErrorToInvocations < ActiveRecord::Migration
  def change
    add_column :invocations, :error, :string
  end
end
