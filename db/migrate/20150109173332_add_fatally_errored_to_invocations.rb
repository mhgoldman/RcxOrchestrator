class AddFatallyErroredToInvocations < ActiveRecord::Migration
  def change
    add_column :invocations, :fatally_errored, :boolean, default: false
  end
end
