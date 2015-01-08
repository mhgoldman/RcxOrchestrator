class AddStartedToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :started, :boolean, default: false
  end
end
