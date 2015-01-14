class AddFatallyErroredToClientSteps < ActiveRecord::Migration
  def change
    add_column :client_steps, :fatally_errored, :boolean, default: false
  end
end
